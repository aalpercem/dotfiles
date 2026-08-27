---
name: ios-notification-scheduling
description: "Patterns for scheduling local iOS notifications that outlive simple repeat triggers: monthly reminders clamped to each month's last valid day, depletion-based rescheduling on app launch, identifier namespacing with prefix-based cancellation, API-driven content reminders, and the 64-pending-request limit. Use when building reminder features, streak protections, or any UNUserNotificationCenter scheduling beyond a daily repeat."
compatibility: opencode
metadata:
  audience: contributors
  platform: ios
---

# iOS Notification Scheduling Patterns

Hard-won patterns from a production reminder system. The core problem: `UNCalendarNotificationTrigger` with `repeats: true` silently skips months where the day doesn't exist (day 31 → skips February), and iOS caps pending local notifications at 64 — so long-horizon schedules need explicit management.

## Pattern 1: Monthly Reminders Clamped to Month End

**Problem:** User picks "remind on the 31st" (or "end of month"). A repeating trigger with `day = 31` fires only in months that have a 31st. Users expect "every month".

**Solution:** Don't rely on OS repetition. Schedule N **non-repeating** triggers, one per upcoming month, clamping the day to each month's length:

```swift
private func makeClampedTriggerPairs(dayOfMonth: Int, hour: Int, minute: Int,
                                     monthsAhead: Int = 2) -> [(String, UNNotificationTrigger)] {
  let calendar = Calendar.autoupdatingCurrent
  let now = Date()
  var pairs: [(String, UNNotificationTrigger)] = []

  for monthOffset in 0..<monthsAhead {
    guard let targetDate = calendar.date(byAdding: .month, value: monthOffset, to: now) else { continue }

    // Clamp: min(requestedDay, actual month length) — Jan 31 becomes Feb 28/29
    let range = calendar.range(of: .day, in: .month, for: targetDate)!
    let clampedDay = min(dayOfMonth, range.last!)

    var components = calendar.dateComponents([.year, .month], from: targetDate)
    components.day = clampedDay
    components.hour = hour
    components.minute = minute

    guard let fireDate = calendar.date(from: components), fireDate > now else { continue }
    pairs.append(("id.m\(monthOffset)", UNCalendarNotificationTrigger(dateMatching: components, repeats: false)))
  }
  return pairs
}
```

Key details:
- `monthsAhead = 2` is enough headroom; more wastes the 64-request budget.
- Skip fire dates already in the past (`fireDate > now`) — e.g. scheduling "the 5th of this month" on the 6th.
- Identifier embeds the month offset (`.m0`, `.m1`) so refresh logic can find them.

## Pattern 2: Depletion-Based Refresh

Clamped schedules run out by design. Instead of background refresh gymnastics, check depletion lazily and top up when the app launches:

```swift
func refreshNotificationsIfNeeded(prefix: String, threshold: Int,
                                  additionalFilter: ((String) -> Bool)? = nil,
                                  action: () async throws -> Void) async throws {
  let requests = await center.pendingNotificationRequests()
  let matching = requests.filter { req in
    guard req.identifier.hasPrefix(prefix) else { return false }
    return additionalFilter?(req.identifier) ?? true
  }
  guard matching.count <= threshold else { return }   // still healthy, do nothing
  try await action()                                   // depleted → reschedule full horizon
}
```

- Call from `RootView`'s `.task` on every launch. Cheap (one pending-list fetch); usually a no-op.
- Threshold < scheduled count (schedule 2 clamped triggers → refresh when ≤ 1 remain): guarantees a refill happens before the last one fires.
- Use `additionalFilter` to scope to one schedule family within a shared prefix (e.g. only identifiers containing `.m`).

## Pattern 3: Identifier Namespacing + Prefix Cancellation

Structure identifiers as `feature.entityId.variant` and cancel whole families by prefix scan:

```
app.notification.manifest.<manifestId>.<reminderId>          (daily)
app.notification.manifest.<manifestId>.<reminderId>.w<weekday>  (weekly)
app.notification.manifest.<manifestId>.<reminderId>.m<monthOffset>  (clamped monthly)
moon-reminder.fullMoon.<epoch>
```

```swift
private func cancelNotifications(withPrefix prefix: String) async {
  let pending = await center.pendingNotificationRequests()
  center.removePendingNotificationRequests(
    withIdentifiers: pending.filter { $0.identifier.hasPrefix(prefix) }.map(\.identifier))
  let delivered = await center.deliveredNotifications()
  center.removeDeliveredNotifications(
    withIdentifiers: delivered.filter { $0.request.identifier.hasPrefix(prefix) }.map(\.request.identifier))
}
```

Cancel delivered notifications too, not just pending. Re-schedule flows should cancel-before-schedule to avoid duplicates.

## Pattern 4: Respect the 64-Pending Limit

Before scheduling loops, count what's already pending and stop at the cap:

```swift
let pendingCount = await center.pendingNotificationRequests().count
var scheduled = 0
for reminder in reminders {
  guard scheduled + pendingCount < 64 else { break }  // log the skip
  ...
}
```

This is why clamped horizons stay short (2 months) and why non-repeating schedules must be refreshed rather than piled up.

## Pattern 5: API-Driven Content Reminders

When trigger dates come from an external source (moon phases, sports fixtures, garbage collection zones):

1. Fetch upcoming events once, filter to future dates, take the next N.
2. Schedule each as a **non-repeating** calendar trigger with full date components.
3. Embed the epoch in the identifier (`phase.<epochSeconds>`) so re-fetches produce stable IDs.
4. Combine with Pattern 2: when pending count for that family drops below N-1, re-fetch and reschedule.

## Pattern 6: Streak Protection (Dual-Slot)

For "don't break the chain" UX, schedule two same-day guards instead of one nag:
- Early slot (morning): gentle nudge if not practiced yet.
- Late slot (evening, `.timeSensitive` interruption level): last-chance warning.
- Compute both from start-of-day; if a slot's time already passed today, drop it (or roll to tomorrow). Recompute daily on launch — after practice, push slots to tomorrow.

## Supporting Conventions

- **Reschedule-all on launch**: one entry point that re-runs every schedule family. Idempotent because of cancel-before-schedule. This also heals drift after timezone changes or restored backups.
- **Localized content without device locale coupling**: build `UNMutableNotificationContent` titles/bodies from localization keys resolved against the user's *in-app* language choice:

```swift
var resource = LocalizedStringResource(stringLiteral: key)
resource.locale = Locale(identifier: appLanguage.rawValue)
content.body = String(localized: resource)
```

- Gate every schedule call behind a single `requireAuthorization()` helper that handles `.notDetermined` prompt, cached denial, and unknown future cases.
- Keep magic numbers (hours ahead, thresholds, monthsAhead) in one fileprivate `Const` enum — they are tuning knobs.

## Reference Implementation

manifestin (`NotificationManager.swift`, ~370 lines): all six patterns in one `@MainActor` manager conforming to a `NotificationProvider` protocol, with `rescheduleAllNotifications(context:)` called from RootView on launch and clamped-refresh mirroring moon-reminder refresh via a shared generic helper.

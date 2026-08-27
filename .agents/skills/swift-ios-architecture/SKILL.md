---
name: swift-ios-architecture
description: "Scaffold or extend an iOS SwiftUI + SwiftData app using a proven architecture blueprint: DIContainer dependency injection, SettingsStore UserDefaults wrapper, @Observable managers, protocol-first networking, Router-based navigation, and a themeable design system. Use when starting a new iOS project, reviewing structure, or wiring DI/storage/services."
compatibility: opencode
metadata:
  audience: contributors
  platform: ios
---

# Swift iOS Architecture Blueprint

A production-proven folder layout and dependency wiring for SwiftUI + SwiftData apps. Start a new project by following the scaffold checklist; extend an existing one by matching the nearest existing pattern.

## Folder Structure

```
<AppName>/
├── App/                    # manifestinApp-like entry point + RootView (TabView)
├── Components/             # reusable views, button styles, cards
│   └── Modifiers/          # reusable View modifiers
├── Core/
│   ├── DIContainer.swift   # the single composition root
│   ├── SettingsStore.swift # UserDefaults-backed observable store
│   ├── DesignSystem/       # theme enum, ThemeProvider palettes, tokens, fonts
│   ├── Navigation/         # Router + AppRoute/AppTab enums
│   ├── Protocols/          # BaseView, ViewState, ViewEvent
│   └── Extensions/         # SwiftUI/Foundation extensions
├── Domain/                 # plain value types: enums, structs, Codable models
├── Managers/               # business logic, persistence coordinators, services
│   └── Notification/
├── Models/                 # SwiftData @Model classes only
├── Networking/             # protocol-first services
│   └── <Feature>/          # one folder per API/domain
│       └── DTO/            # decode-only response types
├── Pages/                  # feature screens: `NameView.swift` + `NameView+Extensions.swift`
├── Resources/              # assets, Color.xcassets, Localizable.xcstrings, bundled JSON
└── Configuration/          # Base.xcconfig + per-dev Local.xcconfig (never committed secrets)
```

Rules: `Models/` holds SwiftData models, `Domain/` holds everything else. One feature screen = one `View` file plus a `View+Extensions` file. Match the nearest existing feature before inventing a new folder.

## Dependency Injection

Composition root is a single `@Observable` singleton. Every service is a `let` property built in `private init()`; nothing is created lazily in views.

```swift
@Observable
final class DIContainer {
  static let shared = DIContainer()

  let router: Router
  let settingsStore: SettingsStore
  let designSystem: DesignSystem
  let hapticManager: HapticManager
  let manifestManager: ManifestManager
  let contentService: ContentService

  private init() {
    self.router = .shared
    self.settingsStore = SettingsStore()
    self.designSystem = DesignSystem(self.settingsStore)
    self.hapticManager = HapticManager(self.settingsStore)
    self.manifestManager = .shared
    self.contentService = LocalContentService.shared
  }
}
```

Injected once at the root, consumed anywhere with the environment.

```swift
@main
struct AppNameApp: App {
  @State var container: DIContainer = .shared

  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(self.container)
    }
    .modelContainer(self.sharedModelContainer)
  }
}
```

Views access services via `@Environment(DIContainer.self)` and typically expose computed aliases in the `+Extensions` file:

```swift
@Environment(DIContainer.self) var container
var palette: ThemeProvider { self.container.designSystem.currentTheme.palette }
var settingsStore: SettingsStore { self.container.settingsStore }
```

## UserDefaults (SettingsStore)

One observable store owns all preferences. Keys are a single `StorageKeys` enum; values go through property wrappers that stay Observation-tracked (`access`/`withMutation`).

```swift
public enum StorageKeys: String, CaseIterable {
  case isOnboardingCompleted
  case currentTheme
  case lastFetchDate
  case cachedSourceIds
}

@Observable
final class SettingsStore {
  init() { Self.registerDefaultValues() }

  static func registerDefaultValues() {
    UserDefaults.standard.register(defaults: [
      StorageKeys.isOnboardingCompleted.rawValue: false,
      StorageKeys.currentTheme.rawValue: "default",
    ])
  }

  @ObservationIgnored @Defaults(.isOnboardingCompleted, defaultValue: false)
  var isOnboardingCompleted: Bool

  @ObservationIgnored @DefaultsRawRepresentable(.currentTheme, defaultValue: .default_)
  var currentTheme: Theme

  @ObservationIgnored @DefaultsOptional(.lastFetchDate)
  var lastFetchDate: Date?

  var userProfile: UserProfile {           // complex Codable = manual JSON encode/decode
    get {
      access(keyPath: \.userProfile)
      guard let data = UserDefaults.standard.data(forKey: StorageKeys.userProfile.rawValue),
            let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
      else { return UserProfile() }
      return profile
    }
    set {
      withMutation(keyPath: \.userProfile) {
        if let data = try? JSONEncoder().encode(newValue) {
          UserDefaults.standard.set(data, forKey: StorageKeys.userProfile.rawValue)
        }
      }
    }
  }
}
```

Property wrappers:

- `@Defaults<T>` — plain stored value with `defaultValue`.
- `@DefaultsRawRepresentable<T>` — stores `.rawValue` for String-backed enums (preferences like theme/font/language).
- `@DefaultsOptional<T>` — nil removes the key (`removeObject`).

`registerDefaultValues()` must run before any property is read — call it from `SettingsStore.init()` (first access builds the container) or explicitly at app launch.

## Managers

Two instantiation patterns; both `@Observable`, both registered on `DIContainer`:

- **Stateless singleton** — `static let shared`, `private init()`. Use for pure coordinators (persistence CRUD, rotation services).
- **Settings-injected** — `init(_ settingsStore: SettingsStore)`. Use when the manager reads preferences (haptics, notifications, sound).

```swift
@Observable
final class ManifestManager {
  static let shared = ManifestManager()
  private init() {}

  @MainActor
  func createManifest(_ text: String, context: ModelContext) throws -> Manifest {
    let manifest = Manifest(text: text)
    context.insert(manifest)
    do { try context.save(); return manifest }
    catch { context.rollback(); throw error }
  }
}
```

Rule: persistence and mutation flows route through managers. Views trigger actions and read state; they never embed storage logic.

## Networking

Protocol-first: define the contract, ship a local/bundled implementation by default, swap in a remote one later without touching callers.

```swift
protocol ContentService {
  func dailySuggestion(for profile: UserProfile) -> DailySuggestion
  func aifests(sourceIds: [String]) -> [AifestResult]
}

final class LocalContentService: ContentService {
  static let shared = LocalContentService()
  private init() {}  // loads bundled JSON into memory once
}
```

For true remote calls, prefer an `actor` (serialized access, safe shared cache):

```swift
actor RemoteService {
  static let shared = RemoteService()
  private let session: URLSession
  private let decoder = JSONDecoder()
  private var cachedDate: Date = .distantPast
  private var cachedValue: Value?

  private init() {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 10
    self.session = URLSession(configuration: config)
  }

  func value(for date: Date) async throws -> Value {
    if self.cachedDate == date, let cachedValue { return cachedValue }
    // fetch, decode DTO, populate cache
  }
}
```

Conventions:

- Decode-only `DTO` structs live in `Networking/<Feature>/DTO/`; never leak DTOs to views — map them to domain types inside the service.
- Preload at launch with a fire-and-forget `Task { try? await ... }` so first screen reads from cache.
- Day-keyed caches belong in `SettingsStore` (`lastFetchDate` + `cachedSourceIds`): first fetch of the day stores IDs, later loads that same day restore by ID instead of refetching.

## Navigation

`AppTab` + `AppRoute` Hashable enums; `Router` singleton holds one path array per tab. `RootView` binds a `NavigationStack(path:)` per tab to the router, and switches on `AppRoute` for destinations.

```swift
enum AppTab: Hashable { case home, explore, profile }
enum AppRoute: Hashable { case settings, statistics, subscription }

@Observable
final class Router {
  static let shared = Router()
  var activeTab: AppTab = .home
  var homeRoutes: [AppRoute] = []
  var profileRoutes: [AppRoute] = []
  func navigate(to route: AppRoute) { ... }       // guards duplicate top route
  func navigateBack() { ... }
  func navigateToRoot() { ... }
}
```

Tab switching clears the old tab's stack and haptics the selection. This keeps every tab's back stack alive independently.

## Design System

Theme = `ThemeProvider` protocol returning palette tokens. One provider class per theme, selected by a String-backed theme enum stored in `SettingsStore`.

```swift
protocol ThemeProvider {
  var primary: MFColor { get }          // decorative: icons, tints, strokes, backgrounds
  var accent: MFColor { get }
  var backgroundPrimary: MFColor { get }
  var textPrimary: MFColor { get }      // text foregrounds only
}

final class DefaultTheme: ThemeProvider { ... }
final class OceanTheme: ThemeProvider { ... }
```

- Wrap color resources in a small value type with an `asColor` conversion to `Color`.
- Text always uses `textPrimary`/`textSecondary`/`textTertiary`; `primary`/`secondary`/`accent` are reserved for decorative use.
- A `LayoutTokens` singleton exposes spacing/radius/icon-size constants.
- Access via `container.designSystem.currentTheme.palette` or the file's local `palette` alias.

## View Conventions

Screens conform to `BaseView` — a thin protocol that owns loading state and wires an event enum:

```swift
protocol BaseView: View {
  var viewState: ViewState { get }
  associatedtype Event: ViewEvent
  @ViewBuilder func contentView() -> Content
  @ViewBuilder func loadingView() -> LoadingView
  func loadInitialData()
  func eventTrigger(_ event: Event)
}
```

- `ViewState` = `idle` / `loading` / `loaded`. Set `viewState = .loaded` when initial data finishes. Default `loadingView()` is a centered `ProgressView`.
- `ViewEvent` is an empty marker protocol; each screen defines its own event enum (`enum ManifestEvent: ViewEvent { ... }`) in the `+Extensions` file and handles actions in `eventTrigger`.
- Screen file structure: `@Environment(DIContainer.self)` → `@State` → `init` → `contentView` → subviews/toolbars. Business logic, computed aliases, and event handling live in `NameView+Extensions.swift`.
- **Scoping rule:** `BaseView` is for Pages (full screens) only. Components, sheet views, and embedded subviews do NOT conform — they receive state and closures from their parent. Don't retrofit a sheet with its own `ViewState` unless it genuinely loads data independently.

## Daily Content Rotation

For "fresh content every day" features (daily suggestions, daily picks), use seeded deterministic rotation instead of random selection or server round-trips:

- Seed = stable per-user key + calendar day. Same seed → same picks all day for that user; different users see different content; it changes at midnight automatically.
- Select from a local JSON bundle at init; score/filter items by user profile attributes, then take the top N under the seed-derived shuffle.
- Cache the day's selected source IDs in the settings store (`lastFetchDate` + IDs). Same-day reloads reuse cached IDs and re-resolve against the current locale instead of re-selecting.
- Track "seen" item IDs per user+date so rotation doesn't repeat within a window.

## Localization

- Single source of truth: `Resources/Localizable.xcstrings`. Use `Text("key")` / `LocalizedStringResource` in views; convert with `String(localized:)` only when a real `String` is needed (e.g. notification content).
- Key naming is feature-scoped: `feature.section.action` (e.g. `profile.section.title`).
- Prefer passing localization keys (not resolved strings) through shared components and models.
- Notifications/localization-sensitive code resolves keys against the stored app-language, not just the system locale.

## Scaffold Checklist

For a new project, in order:

1. Create the folder tree above. Empty `Domain/`, `Managers/`, `Networking/`, `Pages/`; add `Resources/Localizable.xcstrings`.
2. Add `Configuration/Base.xcconfig` + `Local.xcconfig` (Base holds shared settings and `PRODUCT_BUNDLE_IDENTIFIER_BASE`; Local holds per-dev values and is never committed).
3. Build `Core/SettingsStore.swift`: `StorageKeys` enum + property wrappers + `registerDefaultValues()`.
4. Build `Core/DesignSystem/`: `Theme` enum → `ThemeProvider` palettes, color wrapper, `LayoutTokens`.
5. Build `Core/Navigation/Router.swift` with `AppTab`/`AppRoute`.
6. Build `Core/DIContainer.swift` composing steps 3–5 plus empty managers.
7. Build `App/<Name>App.swift` (inject container + modelContainer) and `App/RootView.swift` (TabView + per-tab NavigationStack).
8. Add one sample `Managers/XManager.swift`, one `Networking/XService.swift` + DTO, and one `Pages/XView.swift` + `+Extensions` as reference templates.
9. Register any new Swift Package dependency with an intentional pin.

## When Not To Use

- Small widget/app-extension targets: the container + protocol stack is overkill; use a plain `@Observable` store.
- Apps already using a router library or third-party DI: don't bolt this on top.

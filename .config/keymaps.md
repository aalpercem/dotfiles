# Keymaps Rehberi

> **Oluşturulma:** 2026-06-19
> **Kapsam:** Neovim, WezTerm, Aerospace (macOS Tiling WM)
> **Modifier:** `Ctrl+Alt` — focus/move/workspace/service (Caps Lock ile), `Alt` (Option) — resize/diğer
> **Leader:** `<Space>` (nvim)

---

## 1. Neovim — Genel & Gezinme

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<Esc>` | `:nohlsearch` | `keymaps.lua:1` |
| `n` | `<C-h>` | Smart-splits: sola git | `smart-splits.lua:7` |
| `n` | `<C-j>` | Smart-splits: aşağı git | `smart-splits.lua:8` |
| `n` | `<C-k>` | Smart-splits: yukarı git | `smart-splits.lua:9` |
| `n` | `<C-l>` | Smart-splits: sağa git | `smart-splits.lua:10` |
| `t` | `<Esc><Esc>` | Terminal modundan çık | `keymaps.lua:5` |
| `n` | `<leader>q` | Diagnostic quickfix listesi aç | `keymaps.lua:3` |
| `n` | `<leader>e` | NvimTree aç/kapa | `keymaps.lua:115` |

## 2. Neovim — `<leader>s` (Search — Telescope)

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<leader>sh` | Help tags ara | `telescope.lua:32` |
| `n` | `<leader>sk` | Keymaps ara | `telescope.lua:33` |
| `n` | `<leader>sf` | Dosya ara | `telescope.lua:34` |
| `n` | `<leader>ss` | Telescope builtin seç | `telescope.lua:35` |
| `n` | `<leader>sw` | İmleçteki kelimeyi ara | `telescope.lua:36` |
| `n` | `<leader>sg` | Live grep | `telescope.lua:37` |
| `n` | `<leader>sd` | Diagnostics ara | `telescope.lua:38` |
| `n` | `<leader>sr` | Son aramaya devam et | `telescope.lua:39` |
| `n` | `<leader>s.` | Son dosyalar | `telescope.lua:40` |
| `n` | `<leader>s/` | Açık dosyalarda grep | `telescope.lua:50` |
| `n` | `<leader>sn` | Neovim config dosyalarını ara | `telescope.lua:57` |
| `n` | `<leader><leader>` | Buffer listesi | `telescope.lua:41` |
| `n` | `<leader>/` | Current buffer'da fuzz find | `telescope.lua:43` |

## 3. Neovim — LSP (`g` prefix + `[d`/`]d`, buffer-local)

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `gd` | Definition | `lsp.lua:29` |
| `n` | `gD` | Declaration | `lsp.lua:30` |
| `n` | `gr` | References | `lsp.lua:31` |
| `n` | `gi` | Implementation | `lsp.lua:32` |
| `n` | `gy` | Type Definition | `lsp.lua:33` |
| `n` | `gO` | Document Symbols | `lsp.lua:34` |
| `n` | `gW` | Workspace Symbols | `lsp.lua:35` |
| `n` | `[d` | Previous Diagnostic | `lsp.lua:36` |
| `n` | `]d` | Next Diagnostic | `lsp.lua:37` |
| `n` | `K` | Hover | built-in |
| `n` | `<leader>th` | Toggle inlay hints | `lsp.lua:74` |

## 4. Neovim — LSP Aksiyonları (`<leader>` prefix, buffer-local)

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<leader>rn` | Rename | `lsp.lua:38` |
| `n,x` | `<leader>ca` | Code Action | `lsp.lua:39` |

## 5. Neovim — Xcodebuild (`<leader>x`)

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<leader>X` | Tüm aksiyonları göster | `keymaps.lua:61` |
| `n` | `<leader>xb` | Build | `keymaps.lua:65` |
| `n` | `<leader>xB` | Build for Testing | `keymaps.lua:66` |
| `n` | `<leader>xr` | Build & Run | `keymaps.lua:67` |
| `n` | `<leader>xt` | Testleri çalıştır | `keymaps.lua:70` |
| `v` | `<leader>xt` | Seçili testleri çalıştır | `keymaps.lua:73` |
| `n` | `<leader>xT` | Test class çalıştır | `keymaps.lua:71` |
| `n` | `<leader>x.` | Son testleri tekrarla | `keymaps.lua:72` |
| `n` | `<leader>xe` | Test Explorer aç/kapa | `keymaps.lua:76` |
| `n` | `<leader>xl` | Logları aç/kapa | `keymaps.lua:77` |
| `n` | `<leader>xc` | Code coverage aç/kapa | `keymaps.lua:78` |
| `n` | `<leader>xC` | Coverage raporu göster | `keymaps.lua:79` |
| `n` | `<leader>xp` | Preview generate et | `keymaps.lua:80` |
| `n` | `<leader>x<cr>` | Preview aç/kapa | `keymaps.lua:81` |
| `n` | `<leader>xs` | Failing snapshots | `keymaps.lua:82` |
| `n` | `<leader>xd` | Device seç | `keymaps.lua:85` |
| `n` | `<leader>xq` | QuickFix listesi (Telescope) | `keymaps.lua:86` |
| `n` | `<leader>xx` | Quickfix line | `keymaps.lua:87` |
| `n` | `<leader>xa` | Code actions | `keymaps.lua:88` |
| `n` | `<leader>xf` | Project Manager | `keymaps.lua:62` |

## 6. Neovim — Debug/DAP (`<leader>d`)

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<leader>dd` | Build & Debug | `keymaps.lua:92` |
| `n` | `<leader>dr` | Debug Without Build | `keymaps.lua:95` |
| `n` | `<leader>dt` | Debug Tests | `keymaps.lua:98` |
| `n` | `<leader>dT` | Debug Class Tests | `keymaps.lua:101` |
| `n` | `<leader>db` | Toggle Breakpoint | `keymaps.lua:104` |
| `n` | `<leader>dB` | Toggle Message Breakpoint | `keymaps.lua:107` |
| `n` | `<leader>dx` | Terminate Session | `keymaps.lua:110` |

## 7. Neovim — Git

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<leader>gd` | Diffview aç | `diffview.lua:5` |
| `n` | `<leader>gh` | Diffview File History | `diffview.lua:6` |
| `n` | `<leader>gx` | Diffview kapa | `diffview.lua:7` |
| `n` | `<leader>gg` | LazyGit aç | `lazygit.lua:6` |
| `n` | `<leader>hp` | Gitsigns hunk preview | `gitsigns.lua:15` |
| `n` | `<leader>hr` | Gitsigns hunk reset | `gitsigns.lua:16` |

## 8. Neovim — Diğer

| Mode | Key | Action | Kaynak |
|------|-----|--------|--------|
| `n` | `<leader>f` | Format buffer (conform) | `conform.lua:7` |

## 9. WezTerm

**Kaynak:** `~/.config/wezterm/init.lua`

| Mode | Key | Action | Açıklama |
|------|-----|--------|----------|
| default | `OPT + w` | `CloseCurrentPane` | Pane kapat (onaysız) |
| default | `CTRL + CMD + f` | `ToggleFullScreen` | Tam ekran |
| default | `OPT + h` | `SplitHorizontal` | Yatay split |
| default | `OPT + v` | `SplitVertical` | Dikey split |
| default | `CTRL + h` | `→ vim` ise passthrough, yoksa `ActivatePaneDirection(Left)` | Sola git / vim'e gönder |
| default | `CTRL + j` | `→ vim` ise passthrough, yoksa `ActivatePaneDirection(Down)` | Aşağı git / vim'e gönder |
| default | `CTRL + k` | `→ vim` ise passthrough, yoksa `ActivatePaneDirection(Up)` | Yukarı git / vim'e gönder |
| default | `CTRL + l` | `→ vim` ise passthrough, yoksa `ActivatePaneDirection(Right)` | Sağa git / vim'e gönder |
| default | `CTRL + Tab` | `ActivateTabRelative(1)` | Sonraki tab |
| default | `CTRL + SHIFT + Tab` | `ActivateTabRelative(-1)` | Önceki tab |

---

## 10. Karabiner — Caps Lock

**Kaynak:** `~/.config/karabiner/karabiner.json`

| Durum | Davranış |
|-------|----------|
| **Basılı tut** | `Left Ctrl + Right Option` |
| **Tek tık** | Caps Lock toggle (normal işlev) |

Caps Lock basılıyken Aerospace'e `Ctrl+Alt` modifleri gönderilir.

---

## 11. Aerospace (macOS Tiling WM)

**Kaynak:** `~/dotfiles/.aerospace.toml`
**Karabiner:** Caps Lock basılı = `Ctrl+Alt`
**Caps Lock (Ctrl+Alt):** focus/move/workspace/service, **Sol Alt (⌥):** resize/diğer

### main mode — Focus (Caps Lock + sağ el alt sıra) & Move (Caps Lock + sağ el üst sıra)

| Key | Action | Açıklama |
|-----|--------|----------|
| `Caps Lock + n` | `focus left` | Sol pencere (sağ işaret aşağı) |
| `Caps Lock + m` | `focus down` | Alt pencere (sağ işaret) |
| `Caps Lock + ,` | `focus up` | Üst pencere (sağ orta) |
| `Caps Lock + .` | `focus right` | Sağ pencere (sağ yüzük) |
| `Alt + \`` | `focus-back-and-forth` | Son pencereye dön |
| `Caps Lock + u` | `move left` | Pencereyi sola taşı |
| `Caps Lock + i` | `move down` | Pencereyi aşağı taşı |
| `Caps Lock + o` | `move up` | Pencereyi yukarı taşı |
| `Caps Lock + p` | `move right` | Pencereyi sağa taşı |
| `Alt + -` | `resize smart -50` | Küçült |
| `Alt + =` | `resize smart +50` | Büyüt |

### main mode — Workspace (Caps Lock basılı + sağ el homerow)

Caps Lock basılı = `Left Ctrl + Right Option` → Aerospace `ctrl-alt-*` olarak algılar.

| Key | WS | Parmak |
|-----|----|--------|
| `Caps Lock + h` | 1 | Sağ serçe + sağ işaret sola (homerow) |
| `Caps Lock + j` | 2 | Sağ serçe + sağ işaret (homerow) |
| `Caps Lock + k` | 3 | Sağ serçe + sağ orta (homerow) |
| `Caps Lock + l` | 4 | Sağ serçe + sağ yüzük (homerow) |
| `Caps Lock + ;` | 5 | Sağ serçe + sağ serçe (homerow) |

### main mode — Diğer

| Key | Action |
|-----|--------|
| `Alt + Tab` | `focus-back-and-forth` |
| `Alt + Shift + Tab` | Workspace'i diğer monitöre taşı |
| `Alt + Ctrl + f` | Floating / Tiling toggle |
| `Alt + Shift + Enter` | Fullscreen |
| `Alt + /` | Layout: tiles ↔ horizontal ↔ vertical |
| `Alt + ,` | Layout: accordion horizontal ↔ vertical |

### service mode (Caps Lock + s ile girilir)

Caps Lock basılıyken `s` tuşuna bas → service mode'a gir.
Service mode'da sağ el tuşlarından birine bas → pencereyi workspace'e taşı + otomatik main mode'a dön.

**Hem Caps Lock basılıyken hem de bırakınca çalışır** (ikili binding).

| Key | Action |
|-----|--------|
| `h` | Pencereyi WS 1'e taşı + main mode |
| `j` | Pencereyi WS 2'ye taşı + main mode |
| `k` | Pencereyi WS 3'e taşı + main mode |
| `l` | Pencereyi WS 4'e taşı + main mode |
| `;` | Pencereyi WS 5'e taşı + main mode |
| `Esc` | Config reload + main mode |
| `r` | Flatten workspace tree + main mode |
| `f` | Floating/tiling toggle + main mode |
| `Backspace` | Close all windows but current + main mode |

---

## 12. Çakışma (Conflict) Analizi

| Kısayol | Sahibi | Çakışma? |
|---------|--------|----------|
| `Cmd + A/S/D/F/H` | macOS (Select All, Save, Find, Hide) | **Artık Aerospace'de tanımlı değil** ✅ |
| `Cmd + C/V/X/Z` | macOS (Copy, Paste, Cut, Undo) | **Etkilenmez** ✅ |
| `Cmd + W` | WezTerm (ClosePane) | **Etkilenmez** ✅ |
| `Ctrl + h/j/k/l` | WezTerm pane nav / vim window nav | **Etkilenmez** (`Ctrl+Alt` workspace, `Ctrl` değil) ✅ |
| `Ctrl + d/b` | Vim scroll/page | **Etkilenmez** ✅ |
| `Caps Lock + n,m,<,>` | Aerospace focus | macOS'te kullanılmıyor ✅ |
| `Caps Lock + u,i,o,p` | Aerospace move | macOS'te kullanılmıyor ✅ |
| `Opt + h` | WezTerm (SplitVertical) | **Etkilenmez** (Aerospace'de tanımlı değil) ✅ |
| `Ctrl+Alt + h,j,k,l,;` | Aerospace workspace | macOS'te **hiçbiri kullanılmıyor** ✅ |
| `Ctrl+Alt + s` | Aerospace service mode giriş | macOS'te kullanılmıyor ✅ |

> **Önemli:** `Cmd` prefix'li hiçbir tuş Aerospace'de tanımlı değil. Tüm standart macOS kısayolları (Select All, Save, Find, Copy, Paste, Hide, Close) sorunsuz çalışır.

> **Caps Lock davranışı:** Basılı tutunca `Ctrl+Opt` gönderir, workspace'leri kontrol eder. Tek tıkta normal Caps Lock işlevi devam eder.

## 13. Boş / Kullanılmayan `<leader>` Prefix'leri

| Prefix | Which-key Label | Tanımlı Keymap | Boş Alan |
|--------|----------------|----------------|----------|
| `<leader>t` | [T]oggle | Sadece `th` (inlay hints) | **t** den sonra **çok boş alan var** (ta, tb, tc, td, tf, tg, ti, tj, tk, tl, tm, tn, to, tp, tq, tr, ts, tt, tu, tv, tw, ty, tz) |
| `<leader>h` | Git [H]unk | Sadece `hp`, `hr` | ha, hb, hc, hd, hf, hg, hi, hj, hk, hl, hm, hn, ho, hq, hs, ht, hu, hv, hw, hy, hz |
| `<leader>s` | [S]earch | 13 tane (doygun) | Az boş alan |
| `<leader>d` | Debug / DAP | 7 tane (`dd`, `dr`, `dt`, `dT`, `db`, `dB`, `dx`) | Doygun sayılır |
| `<leader>x` | Xcodebuild | 20 tane | Doygun |

## 14. Geçmişten Gelen Değişiklikler

| Eski Key | Yeni Key | Aksiyon | Değişim Tarihi |
|----------|----------|---------|----------------|
| `grd` | `gd` | LSP: Definition | 2026-05-13 |
| `grD` | `gD` | LSP: Declaration | 2026-05-13 |
| `grr` | `gr` | LSP: References | 2026-05-13 |
| `gri` | `gi` | LSP: Implementation | 2026-05-13 |
| `grt` | `gy` | LSP: Type Definition | 2026-05-13 |
| `grn` | `<leader>rn` | LSP: Rename | 2026-05-13 |
| `gra` | `<leader>ca` | LSP: Code Action | 2026-05-13 |
| — | `[d` / `]d` | Diagnostic prev/next | 2026-05-13 (yeni) |
| `<leader>b` | `<leader>db` | DAP: Toggle Breakpoint | 2026-05-13 |
| `<leader>B` | `<leader>dB` | DAP: Message Breakpoint | 2026-05-13 |
| `Cmd + a/s/d/f/g/h/j/k/l` | `Caps Lock + h/j/k/l/;/u/i/o/p` | Aerospace workspace | 2026-05-17 |
| `Cmd + Shift + a/s/...` | Service mode (`Caps Lock + s` + tuş) | Aerospace move to WS | 2026-05-17 |
| `Alt + h/j/k/l` | `Alt + y/u/i/o` | Aerospace focus | 2026-05-17 |
| `WezTerm: Ctrl+d/b` | `WezTerm: Opt+h/v` | Split Horizontal/Vertical | 2026-05-17 (doc fix) |
| `Alt + y/u/i/o` | `Caps Lock + n/m/,/.` | Aerospace focus (Caps Lock alt sıra) | 2026-06-19 |
| `Alt + Shift + y/u/i/o` | `Caps Lock + u/i/o/p` | Aerospace move (Caps Lock üst sıra) | 2026-06-19 |
| `Caps Lock + u/i/o/p` | *kaldırıldı* | Aerospace WS 6-9 (move'e devredildi) | 2026-06-19 |

## 15. Toplu İstatistik

| Kategori | Sayı |
|----------|------|
| **Neovim — Genel** | 7 |
| **Neovim — Telescope (search)** | 13 |
| **Neovim — LSP** (`g` prefix, `[]`, `<leader>`) | 11 |
| **Neovim — Xcodebuild** | 20 |
| **Neovim — DAP/Debug** | 7 |
| **Neovim — Git** | 6 |
| **Neovim — Diğer** | 1 |
| **WezTerm** | 9 |
| **Aerospace** | 31 |
| **Karabiner** | 1 |
| **Toplam** | **106** |

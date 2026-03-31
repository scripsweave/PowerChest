# PowerChest

**The `defaults write` GUI that macOS should have shipped with.**

Remember Windows PowerToys? That glorious grab-bag of utilities that gave you *actual control* over your own computer? PowerChest is that energy for macOS — a native SwiftUI app that surfaces 80+ hidden system settings, network controls, and firewall toggles through a clean GUI. No Terminal required. Every change is snapshotted, logged, and reversible.

macOS hides a remarkable amount of useful behavior behind `defaults write` commands that most people never discover. PowerChest puts them all in one place with plain-language descriptions, risk badges, and a Time Machine for your settings.

<p align="center">
<strong>Show hidden files → Disable mouse acceleration → Enable firewall stealth mode → Stop .DS_Store pollution</strong>
<br>
<em>All without opening Terminal once.</em>
</p>

## Why this exists

Every macOS power user has a `setup.sh` full of `defaults write` commands they cargo-cult from blog posts and dotfiles repos. Half of them are outdated. None of them explain what they actually do. And if something breaks, good luck remembering which incantation caused it.

PowerChest replaces that script with:

- **Auto-snapshots** before every change — go back to any point in time
- **Full audit trail** — what changed, when, from which mode, with old and new values
- **Risk badges** — know if a setting is safe, advanced, or system-sensitive before you flip it
- **Restart handling** — automatic Dock/Finder/SystemUIServer restarts when needed
- **Config export/import** — `.powerchestprofile` files to transfer your setup between machines
- **One-click presets** — opinionated bundles like "Developer Desk" or "Snappy Mac"

## What's in the box

### 80+ settings across 10 categories

| Category | Highlights |
|----------|-----------|
| **Finder & Files** | Hidden files, ~/Library, .DS_Store cleanup, path bar, extensions, new window target |
| **Dock & Interface** | Speed, size, position, minimize animation, recent apps, App Nap, scroll bars |
| **Keyboard & Input** | Key repeat speed, accent popup, smart quotes/dashes, autocorrect, **mouse acceleration curves** |
| **Windows & Spaces** | Fixed Space order, Mission Control speed, grouping, separate Spaces per display |
| **Screenshots** | Location, format, shadows, thumbnail, filename prefix |
| **Safari & Developer** | Full URL, dev tools, auto-open downloads, status bar |
| **Visuals & Accessibility** | Transparency, contrast, motion, cursor size, **font smoothing for non-Retina monitors** |
| **Menu Bar** | 24-hour clock, battery %, date format, flash separators |
| **Safety & Security** | Quarantine bypass, crash reporter detail level |
| **Network & Connectivity** | **Firewall** (stealth mode, block-all), .DS_Store on network/USB, AirDrop, captive portal, SSH, IPv6, Bluetooth audio quality, **MAC address spoofing**, Safari DNS prefetching, Do Not Track |

### Settings you won't find in System Settings

These are the ones that justify the app's existence — things Apple hides or removed:

- **Disable mouse acceleration** — set `com.apple.mouse.scaling` to -1 for raw input. Gamers and designers, this one's for you.
- **Font smoothing on non-Retina displays** — Apple removed the checkbox in Mojave. The `defaults` key still works. If text looks thin on your external monitor, this fixes it.
- **Disable App Nap** — stop macOS from secretly pausing your background apps to "save energy."
- **Firewall stealth mode** — makes your Mac invisible to pings and port scans. One toggle.
- **Captive portal detection** — stop macOS from phoning home to Apple every time you join Wi-Fi.
- **MAC address spoofing** — per-interface, with validation and one-click randomization. Reverts on reboot.
- **.DS_Store suppression** — stop Finder from littering metadata files on every network share and USB drive you touch.
- **Bluetooth audio bitpool** — the default minimum is absurdly low. Crank it up for better AirPods quality.

### Two modes

- **Power User** — plain-language controls grouped by intent ("Make the Dock feel faster", not `autohide-delay`). Cards with descriptions, risk badges, and admin indicators.
- **Propellerhead** — every individual setting with its domain, key path, value type, and a slider or text field. For people who think in `defaults write`.

### Presets

One-click opinionated bundles. Auto-snapshot before apply.

| Preset | What it does |
|--------|-------------|
| **Snappy Mac** | Faster Dock, faster Mission Control, faster key repeat |
| **Developer Desk** | Hidden files, extensions, ~/Library, plain text TextEdit, no smart quotes, Safari dev tools |
| **Clean Screenshots** | PNG format, no window shadows, tidy filenames |
| **Solid UI** | Reduced transparency, increased contrast |
| **Minimal Fuss** | No Dock recents, fixed Spaces, no smart punctuation |

### Time Machine for settings

Every change auto-creates a snapshot. Browse them by date, compare against current state, restore individual settings or entire snapshots. Snapshots are never pruned — go back as far as you want.

### Config portability

Export your setup as a `.powerchestprofile` file. Import it on another Mac. A diff preview shows exactly what will change before you apply.

## Admin settings

Some settings (firewall, SSH, captive portal, MAC spoofing) require admin privileges. PowerChest shows a lock badge on these and prompts for your password via the standard macOS auth dialog when you apply. The auth is cached for ~5 minutes so bulk changes only prompt once.

## Building

```bash
# Clone and open in Xcode
open Xcode/PowerChest/PowerChest.xcodeproj

# Or build from the command line
xcodebuild -project Xcode/PowerChest/PowerChest.xcodeproj \
  -scheme PowerChest -configuration Debug build
```

Requires **macOS 14.0+** (Sonoma) and **Xcode 16+**.

The app runs outside the sandbox (it needs to run `defaults write`, `killall`, `ifconfig`, etc.) with Hardened Runtime enabled. Not App Store compatible by design — this is a power tool, not a consumer app.

## Architecture

For the curious:

- **Apply Engine** — single mutation pipeline with 12-step transaction lifecycle. All changes (manual, presets, restores, imports) go through the same path.
- **Snapshot Service** — captures setting state before every mutation. JSON files in `~/Library/Application Support/PowerChest/Snapshots/`.
- **Settings Catalog** — 80+ curated settings as bundled Swift data. Not runtime discovery — every setting is hand-verified.
- **Four adapters** — `DefaultsAdapter` (UserDefaults fast path for reads, CLI for writes), `CommandAdapter` (chflags), `PrivilegedAdapter` (admin operations via AppleScript), `RestartService` (killall for system processes).
- **SwiftUI + @Observable** — native macOS app, no Electron, no web views, no Catalyst.

See `CLAUDE.md` for detailed architecture notes and `specifications/` for design documents.

## Philosophy

- Every change must be reversible with a clear rollback path
- Auto-snapshot before every mutation — no exceptions
- Current system values are always re-read, never cached as truth
- The catalog is curated and bundled, not scraped from the system
- Smart, dry, slightly cheeky — never cutesy, never obscure in critical flows

## License

MIT License. See [LICENSE](LICENSE) for details.

---

*Built with SwiftUI for macOS. No Electron was harmed in the making of this app.*

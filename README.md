# PowerChest

A macOS utility for changing advanced system settings safely, reversibly, and without terminal use.

PowerChest looks and feels like macOS System Settings — same layout, same controls, same spatial logic — but with personality. Where System Settings is neutral, PowerChest is opinionated, dry, and occasionally amusing.

## What it does

PowerChest exposes 66 curated macOS settings that are normally only accessible via `defaults write` commands or buried deep in system preferences. Every change is:

- **Reversible** — automatic snapshots before every mutation
- **Logged** — full audit trail of what changed, when, and why
- **Safe** — risk badges, restart warnings, and clear rollback paths

## Two modes

- **Power User** — plain-language controls grouped by intent ("Make the Dock feel faster", not `autohide-delay`)
- **Propellerhead** — individual settings with technical details, domains, key paths, and sliders

## Categories

| Category | Examples |
|----------|----------|
| Finder & Files | Show ~/Library, hidden files, .DS_Store cleanup, Trash warnings |
| Dock & Interface | Speed, size, position, minimize animation, recent apps |
| Keyboard & Input | Key repeat, smart quotes, autocorrect, full keyboard access |
| Windows & Spaces | Mission Control speed, grouping, separate Spaces per display |
| Screenshots | Location, format, shadows, filename prefix |
| Browser & Developer | Safari full URL, dev menu, auto-open downloads, status bar |
| Visuals & Accessibility | Transparency, contrast, motion, cursor size |
| Menu Bar | Battery %, 24-hour clock, date display |
| Safety & Security | Quarantine, crash reporter detail |

## Presets

One-click bundles of opinionated changes:

- **Snappy Mac** — faster Dock, faster Mission Control, faster key repeat
- **Developer Desk** — hidden files, extensions, ~/Library, plain text TextEdit, no smart quotes, Safari dev tools
- **Clean Screenshots** — PNG format, no shadows
- **Solid UI** — reduced transparency, increased contrast
- **Minimal Fuss** — no Dock recents, no auto-rearrange Spaces, no smart punctuation

## Requirements

- macOS 14.0+ (Sonoma)
- Xcode 16+

## Building

```bash
open Xcode/PowerChest/PowerChest.xcodeproj
# or
xcodebuild -project Xcode/PowerChest/PowerChest.xcodeproj -scheme PowerChest build
```

## Architecture

- **Apply Engine** — single mutation pipeline for all changes (direct edits, presets, restores, imports)
- **Snapshot Service** — Time Machine for settings; auto-snapshot before every mutation
- **Settings Catalog** — 66 curated settings as bundled Swift data, not runtime discovery
- **Two adapters** — `DefaultsAdapter` (most settings) and `CommandAdapter` (chflags for ~/Library)

See `CLAUDE.md` for detailed architecture notes and `specifications/` for design documents.

## License

Private project. All rights reserved.

# CLAUDE.md

This repository contains the native Swift/SwiftUI rewrite of the wellbeing-app (originally Next.js/React).

## Reference

- Original web app: https://github.com/Ulitz/wellbeing-app/tree/codex/UI-Redesign
- Reference code cloned to: `wellbeing-app-ref/` (gitignored)
- Master prompt: `PROMPT.md` — comprehensive build specification

## Commands

```bash
# Build (once Xcode project exists)
xcodebuild -scheme WellbeingApp -destination 'platform=iOS Simulator,name=iPhone 16' build

# Test
xcodebuild -scheme WellbeingApp -destination 'platform=iOS Simulator,name=iPhone 16' test

# Open in Xcode
open WellbeingApp.xcodeproj
```

## Architecture

**SwiftUI App** — iOS 17+, Hebrew RTL, no backend, all data on-device.

### Key Directories (planned)
- `Models/` — Codable structs and enums matching the original TypeScript types
- `Storage/` — UserDefaults / SwiftData persistence layer
- `Engines/` — Pure business logic (scoring, flags, recommendations, personalization)
- `Views/` — SwiftUI views organized by screen
- `Components/` — Reusable UI primitives (GlassCard, PrimaryButton, etc.)
- `Theme/` — Design tokens, colors, typography
- `Data/` — Static exercise/question/text data with Hebrew content
- `Tests/` — Unit + Integration + UI tests

### Sub-Agent Usage

This project uses Claude Code sub-agents extensively. See PROMPT.md for the full agent assignment table. Key agents:
- `everything-claude-code:planner` — Plan before each phase
- `everything-claude-code:tdd-guide` — Write tests first
- `everything-claude-code:code-reviewer` — Review every file change
- `everything-claude-code:security-reviewer` — Review storage + contacts + notifications
- `frontend-design:frontend-design` — High design quality

## Key Conventions

- **Language**: All user-facing text is Hebrew (RTL). Code is in English.
- **Font**: Heebo (Hebrew-optimized)
- **Design**: Glass-morphism cards, spring animations, haptic feedback
- **Storage**: No network calls. UserDefaults or SwiftData only.
- **Testing**: TDD approach. 80%+ coverage target. XCUITest for E2E.

# react-native-nitro-toast

A lightweight, native-powered toast notification library for React Native built with **Nitro Modules** (SwiftUI on iOS, Jetpack Compose on Android). Zero bridge overhead — JSI-native via the Nitro abstraction layer.

**npm:** `react-native-nitro-toast` · **version:** 1.3.1
**Repo:** `kiethuynh0904/react-native-nitro-toast` · **default branch:** `master`

---

## Architecture

The library is split into three layers that must stay in sync:

```
src/specs/NitroToast.nitro.ts   ← TypeScript interface (source of truth)
        ↓  bun run specs
nitrogen/                        ← auto-generated bridge (DO NOT edit)
        ↓
ios/NativeIntegration/HybridNitroToast.swift    ← iOS entry point
android/.../HybridNitroToast.kt                 ← Android entry point
```

### TypeScript layer (`src/`)

| File | Role |
|------|------|
| `src/specs/NitroToast.nitro.ts` | Nitro `HybridObject` interface — defines `show()` and `dismiss()` |
| `src/index.ts` | Public API: `showToast`, `dismissToast`, `showToastPromise`, `defaultToastConfig` |
| `src/types.ts` | Additional types: `ToastPromiseMessages`, `ToastPromiseConfig` |

Public API is instantiated via:
```ts
const NitroToastModule = NitroModules.createHybridObject<NitroToast>('NitroToast')
```

### iOS layer (`ios/`)

| File | Role |
|------|------|
| `NativeIntegration/HybridNitroToast.swift` | Nitro entry point — dispatches to `ToastViewModel` on main thread |
| `ViewModels/ToastViewModel.swift` | `@MainActor` singleton — owns `UIWindow` and `[Toast]` state |
| `NativeIntegration/PassthroughView.swift` | Custom `UIWindow` subclass that passes touches through |
| `Views/ToastListView.swift` | Alert-mode SwiftUI view |
| `Views/ToastStackView.swift` | Stacked-mode SwiftUI view |
| `Views/ToastIconView.swift` | Icon renderer (predefined types + custom `iconUri`) |
| `Model/Toast.swift` | `Toast` model (ObservableObject) |
| `Helpers/Color+Extensions.swift` | Hex string → `Color` conversion |
| `Assets.xcassets/` | Named color assets for each toast type |

**iOS runtime flow:**
1. `HybridNitroToast.show()` receives call from JS thread
2. Dispatches to `DispatchQueue.main` → `ToastViewModel.shared.present()`
3. If no window exists: creates `PassthroughWindow` at `windowLevel: .alert + 1`, hosts a SwiftUI view
4. `ToastViewModel.emit()` appends to `@Published var toasts`, starts an async countdown task
5. On dismiss: removes from array, tears down `UIWindow` when list is empty

### Android layer (`android/src/main/java/com/margelo/nitro/nitrotoast/`)

| File | Role |
|------|------|
| `HybridNitroToast.kt` | Nitro entry point — delegates to `ToastManager` |
| `ToastManager.kt` | `object` singleton — manages `ComposeView` on `decorView`, coroutine lifecycle |
| `ToastListState.kt` (inside ToastManager.kt) | `MutableStateFlow`-based state for the toast list |
| `ToastList.kt` | Compose rendering (alert + stacked modes) |
| `Toast.kt` | Data class |
| `ToastIcon.kt` | Icon Compose component |
| `DraggableToast.kt` | Swipe-to-dismiss gesture wrapper |
| `Utils.kt` | Hex → `Color`, other utilities |

**Android runtime flow:**
1. `HybridNitroToast.show()` receives call on Nitro thread
2. Delegates to `ToastManager.show()` with the Activity from `NitroModules.applicationContext`
3. `ensureToastContainer()` adds a `ComposeView` to `window.decorView` if not present
4. Coroutine launches `handleToastLifecycle()`: sets visible after 16ms frame delay, auto-dismisses after duration
5. On dismiss: `removeWithAnimation()` hides then removes; container detached when list empty

### Nitro codegen (`nitrogen/`, `nitro.json`)

`nitro.json` configures the Nitro build:
- `cxxNamespace`: `["nitrotoast"]`
- iOS module name: `NitroToast` (autolinking: `HybridNitroToast` Swift class)
- Android namespace: `nitrotoast`, CXX lib: `NitroToast` (autolinking: `HybridNitroToast` Kotlin class)

`nitrogen/` contains auto-generated C++ bridge, Swift specs, and Kotlin specs.
**Never edit files in `nitrogen/` manually.**

---

## Key Commands

```bash
bun run typecheck          # TypeScript type check (no emit)
bun run lint               # ESLint with auto-fix
bun run specs              # tsc + nitro-codegen (regenerate nitrogen/)
bun run prepare            # react-native-builder-bob build → lib/
bun run format:ios         # swiftformat ios/
bun run format:android     # ktlint -F android/src/**/*.kt
bun run release            # release-it (version bump + CHANGELOG + npm publish)
```

**Never edit `lib/` directly** — it is build output from `bun run prepare`.

---

## Nitro Interface Change Workflow

When changing the public native API (adding/removing methods or types in `NitroToast.nitro.ts`):

1. Edit `src/specs/NitroToast.nitro.ts`
2. Run `bun run specs` — this regenerates `nitrogen/`
3. Update `ios/NativeIntegration/HybridNitroToast.swift` to implement new methods
4. Update `android/.../HybridNitroToast.kt` to implement new methods
5. Both platforms must compile before opening a PR

If only changing TypeScript helpers (`src/index.ts`, `src/types.ts`), no codegen is needed.

---

## Release Process

Releases are managed by `release-it`. The CHANGELOG is auto-generated from git commits by `auto-changelog` — do not manually edit `CHANGELOG.md`.

Version bump rules:
- **Patch** (`x.x.X`): bug fixes, no API change
- **Minor** (`x.X.0`): new optional props or methods, additive only
- **Major** (`X.0.0`): breaking changes (removed export, renamed prop, changed signature)

```bash
bun run release   # interactive: choose version, tags, publishes to npm
```

---

## Conventions

### Git & PRs

Branch naming:
```
fix/<issue-number>-<short-slug>    # for GitHub issue fixes
feat/<short-slug>                  # for new features
chore/<short-slug>                 # for maintenance
```

Commit messages follow **Conventional Commits**:
```
fix: correct bottom position offset on Android (closes #42)
feat: add haptics support for loading type
chore: regenerate nitrogen specs for nitro-modules 0.35.0
docs: document iconUri usage
```

PRs always target `master`. No `develop` branch.

### Code style

**TypeScript:**
- All new public exports must have explicit types — no `any` on the public surface
- `src/index.ts` is the only public export barrel
- Internal helpers may live in `src/` but must not be re-exported unless intentional

**Swift:**
- `swiftformat` applied before committing (`bun run format:ios`)
- Main-thread UI work via `DispatchQueue.main.async` or `@MainActor`
- Singleton state via `ToastViewModel.shared`

**Kotlin:**
- `ktlint` applied before committing (`bun run format:android`)
- UI work via `context.runOnUiThread` or `Dispatchers.Main`
- Singleton state via `object ToastManager`
- Coroutines for async lifecycle management

### Example app

The example app lives in `example/`. It must be updated whenever a change affects observable behaviour (new props, new toast type, visual changes). New features need a demo.

---

## Quality Gates (required before any PR)

- [ ] `bun run typecheck` — zero errors
- [ ] `bun run lint` — zero errors
- [ ] `bun run format:ios` applied (if iOS files changed)
- [ ] `bun run format:android` applied (if Android files changed)
- [ ] Both iOS and Android compile without warnings (for native changes)
- [ ] `nitrogen/` regenerated if `nitro.json` or `.nitro.ts` changed
- [ ] Example app updated if behaviour changed
- [ ] README updated if public API changed

---

## Workflow Skills

Use `/dora` to run the project workflow:

```
/dora fix    — pick up a GitHub issue and fix it end-to-end
/dora build  — build a new feature following project patterns
/dora pr     — run pre-PR checklist and open a pull request
/dora prx    — review a PR against the project's focus points
```

# Architecture Overview

`react-native-nitro-toast` is a lightweight, native-powered toast notification
library for React Native, built on **[Nitro Modules](https://nitro.margelo.com)**.
The UI is rendered with **SwiftUI on iOS** and **Jetpack Compose on Android** —
there is no legacy bridge serialization; calls cross into native code via JSI
through the Nitro abstraction layer.

This document explains how the pieces fit together. For day-to-day usage see the
[README](./README.md); for contributor workflows and commands see [CLAUDE.md](./CLAUDE.md).

---

## High-level picture

```
┌──────────────────────────────────────────────────────────────┐
│  JavaScript / TypeScript (your app)                            │
│                                                                │
│   showToast() · dismissToast() · showToastPromise()            │
│                         │                                      │
│        src/index.ts  ───┘  (public API + default config)       │
│                         │                                      │
│   NitroModules.createHybridObject<NitroToast>('NitroToast')    │
└─────────────────────────┬──────────────────────────────────── ┘
                          │  JSI (zero bridge overhead)
            ┌─────────────┴─────────────┐
            ▼                           ▼
┌────────────────────────┐   ┌────────────────────────┐
│  iOS (Swift + SwiftUI) │   │ Android (Kotlin/Compose)│
│                        │   │                         │
│  HybridNitroToast      │   │  HybridNitroToast       │
│        │               │   │        │                │
│  ToastViewModel        │   │  ToastManager           │
│   (UIWindow owner)     │   │  (decorView overlay)    │
│        │               │   │        │                │
│  SwiftUI Toast views   │   │  Compose Toast views    │
└────────────────────────┘   └────────────────────────┘
```

The library is intentionally split into three layers that **must stay in sync**:

```
src/specs/NitroToast.nitro.ts   ← TypeScript interface (the source of truth)
        │  bun run specs  (tsc + nitro-codegen)
        ▼
nitrogen/                        ← auto-generated C++/Swift/Kotlin bridge  (DO NOT edit)
        ▼
ios/.../HybridNitroToast.swift   ← iOS implementation
android/.../HybridNitroToast.kt  ← Android implementation
```

If you change the native-facing interface (`show` / `dismiss` / `NitroToastConfig`),
you must regenerate `nitrogen/` and update **both** native implementations.

---

## The contract: `NitroToast.nitro.ts`

Everything starts from a single Nitro `HybridObject` interface in
[`src/specs/NitroToast.nitro.ts`](./src/specs/NitroToast.nitro.ts):

```ts
export interface NitroToast extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  show(message: string, config: NitroToastConfig): string  // returns toastId
  dismiss(toastId: string): void
}
```

The surface is deliberately tiny — just two methods. All visual/behavioral
configuration is carried in the `NitroToastConfig` value object (type, presentation,
duration, position, colors, overlay, haptics, custom icon, font family). Keeping the
method count small means the native bridge rarely needs regeneration; most feature
work is additive fields on the config object.

`nitro.json` ties this interface to the native classes via autolinking:
both platforms register a class literally named `HybridNitroToast`, under the
`NitroToast` module / `nitrotoast` C++ namespace.

---

## TypeScript layer (`src/`)

| File | Role |
|------|------|
| [`src/specs/NitroToast.nitro.ts`](./src/specs/NitroToast.nitro.ts) | The Nitro interface + `NitroToastConfig` — the source of truth |
| [`src/index.ts`](./src/index.ts) | Public API barrel: `showToast`, `dismissToast`, `showToastPromise`, `defaultToastConfig` |
| [`src/types.ts`](./src/types.ts) | Helper types for the promise API (`ToastPromiseMessages`, `ToastPromiseConfig`) |

The public API is a thin ergonomic wrapper over the raw Nitro object:

- **`showToast(message, config?)`** merges the caller's partial config over
  `defaultToastConfig`, applies one smart default (a `loading` toast defaults to
  `duration: 0` so it never auto-dismisses), then calls into native and returns the
  toast id.
- **`dismissToast(id)`** forwards straight to the native `dismiss`.
- **`showToastPromise(promise, messages, config)`** shows a `loading` toast, awaits
  the promise, then **reuses the same `toastId`** to morph it into a `success` or
  `error` toast — so the user sees one toast transition states rather than three
  separate toasts.

`src/index.ts` is the **only** public export barrel. Internal helpers must not be
re-exported unless intentional, and all public exports carry explicit types.

---

## iOS layer (`ios/`)

| File | Role |
|------|------|
| `NativeIntegration/HybridNitroToast.swift` | Nitro entry point; hops to the main thread |
| `ViewModels/ToastViewModel.swift` | `@MainActor` singleton; owns the `UIWindow` and `[Toast]` state |
| `NativeIntegration/PassthroughView.swift` | `UIWindow` subclass that lets touches fall through to the app |
| `Views/ToastListView.swift` | Alert-mode SwiftUI rendering |
| `Views/ToastStackView.swift` | Stacked-mode SwiftUI rendering |
| `Views/ToastIconView.swift` | Icon renderer (predefined types + custom `iconUri`) |
| `Model/Toast.swift` | `Toast` model (`ObservableObject`) |
| `Helpers/Color+Extensions.swift` | Hex string → SwiftUI `Color` |

**Runtime flow:**

1. `HybridNitroToast.show()` is called from the JS thread. It resolves a `toastId`
   (caller-provided or a fresh `UUID`) and immediately returns it, dispatching the
   real work to `DispatchQueue.main`.
2. `ToastViewModel.shared.present()` runs on the main actor. If no toast window
   exists yet, it lazily creates a `PassthroughWindow` at `windowLevel: .alert + 1`
   and hosts a SwiftUI view in it — so toasts float above the entire app, including
   modals, without blocking touches.
3. The view model appends to its `@Published var toasts` array and starts an async
   countdown task for auto-dismiss.
4. On dismiss (timeout or explicit `dismiss(toastId:)`), the toast is removed from
   the array; when the array becomes empty the `UIWindow` is torn down so nothing
   lingers.

Because the id is returned synchronously before the UI work runs, the JS
`showToastPromise` flow can reliably target the same toast across state changes.

---

## Android layer (`android/.../nitrotoast/`)

| File | Role |
|------|------|
| `HybridNitroToast.kt` | Nitro entry point; delegates to `ToastManager` |
| `ToastManager.kt` | `object` singleton; owns the `ComposeView` overlay and coroutine lifecycle |
| `ToastList.kt` | Compose rendering (alert + stacked modes) |
| `ToastView.kt` | Individual toast composable |
| `ToastIcon.kt` | Icon composable |
| `DraggableToast.kt` | Swipe-to-dismiss gesture wrapper |
| `Toast.kt` | Data class |
| `Utils.kt` | Hex → `Color` and other helpers |

**Runtime flow:**

1. `HybridNitroToast.show()` is called on the Nitro thread. It resolves a `toastId`
   (caller-provided or a fresh `UUID`), then grabs the current `Activity` from
   `NitroModules.applicationContext` and delegates to `ToastManager.show(...)`.
2. `ToastManager.ensureToastContainer()` attaches a `ComposeView` to the activity's
   `window.decorView` if one isn't already present — this is the overlay surface that
   hosts all toasts.
3. A coroutine runs `handleToastLifecycle()`: it waits one frame (~16ms) before
   marking the toast visible (so the enter animation runs), then auto-dismisses after
   the configured duration.
4. On dismiss, `removeWithAnimation()` animates the toast out and removes it from
   state; when the list is empty the `ComposeView` container is detached from
   `decorView`.

State is held in a `MutableStateFlow`-backed list inside `ToastManager`, which the
Compose tree observes — the Kotlin analogue of iOS's `@Published` array.

---

## Cross-platform symmetry

Both platforms follow the same shape, which makes the codebase easy to reason about:

| Concern | iOS | Android |
|---------|-----|---------|
| Entry point | `HybridNitroToast` (Swift) | `HybridNitroToast` (Kotlin) |
| Singleton state owner | `ToastViewModel.shared` | `object ToastManager` |
| Overlay surface | dedicated `PassthroughWindow` | `ComposeView` on `decorView` |
| Reactive state | `@Published var toasts` | `MutableStateFlow` |
| Threading | `DispatchQueue.main` / `@MainActor` | `runOnUiThread` / `Dispatchers.Main` |
| Auto-dismiss | async countdown task | coroutine lifecycle |
| Touch passthrough | `PassthroughView` window | overlay added without intercepting input |

`toastId` is the shared currency across both layers and both platforms: it's how a
toast is updated in place (e.g. loading → success) and how it's explicitly dismissed.

---

## Codegen (`nitrogen/`) — do not edit

`bun run specs` runs `tsc` then `nitro-codegen`, regenerating the `nitrogen/`
directory: the C++ JSI bridge, Swift specs (`HybridNitroToastSpec`), and Kotlin specs
(`HybridNitroToastSpec`). The native implementations subclass/conform to these
generated specs. **Never edit `nitrogen/` by hand** — changes are overwritten on the
next codegen run. Regenerate whenever `nitro.json` or any `*.nitro.ts` file changes.

---

## Build & distribution

- `bun run prepare` builds `src/` → `lib/` via `react-native-builder-bob`. `lib/` is
  build output — never edit it directly.
- iOS is consumed as a CocoaPod via `NitroToast.podspec`; Android as a Gradle module
  (`android/build.gradle`, `CMakeLists.txt`).
- The `example/` app is the living integration test and demo surface; it should be
  updated whenever observable behavior changes.

---

## Adding a feature — the mental model

1. **Additive config field?** Add it to `NitroToastConfig` in the `.nitro.ts` file,
   run `bun run specs`, then read it in both `ToastViewModel` (iOS) and `ToastManager`
   / Compose views (Android). No new method needed → minimal bridge churn.
2. **New method on the interface?** Edit `.nitro.ts`, regenerate, implement in both
   `HybridNitroToast.swift` and `HybridNitroToast.kt`. Both platforms must compile.
3. **JS-only ergonomics?** (e.g. another promise helper) Add to `src/index.ts` /
   `src/types.ts` — no codegen required.

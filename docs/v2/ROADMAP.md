# react-native-nitro-toast — v2 Roadmap

> Status: **Planning**
> This document is the high-level map for v2. Each item links to a detailed
> implementation plan under [`./plans/`](./plans/) (created when the item is picked up).
> Use [`./plans/_TEMPLATE.md`](./plans/_TEMPLATE.md) as the starting point for a new plan.

For the current design see [ARCHITECTURE.md](../../ARCHITECTURE.md).
**To start building, follow the ordered playbook → [IMPLEMENTATION.md](./IMPLEMENTATION.md).**

---

## Scope decision (locked)

v2 stays a **focused, single-purpose toast library** — do one thing extremely well.
**Out of scope (decided):** alert / dialog / confirm subsystems. The passthrough,
non-blocking interaction model of a toast is the opposite of a modal alert; mixing
them would dilute the library. Use a dedicated dialog library for that need.

`show()` keeps its **upsert** behavior (same `toastId` → update in place). This is the
established, familiar API and will not be split into a separate `update()`.

## Goals for v2

1. **Performance first** — make the single toast pipeline excellent: kill the timer
   busy-loop, tighten the lifecycle, zero wasted wakeups/leaks.
2. **First-class iPad & Android tablet** — adaptive layout for large/regular size
   classes and multi-window.
3. Pay down **timer / lifecycle** tech debt that differs across platforms.
4. Add **CI + tests** so v2 ships with confidence.
5. Keep the native-bridge surface small — batch any interface changes into a single
   codegen round.

Legend: 🔴 breaking · 🟢 non-breaking · ⚙️ infra · effort `S`/`M`/`L`

---

## Workstream 1 — Optimizations (tech debt)

Grounded in current code; most are **non-breaking** and can ship in v1.x before v2.

| # | Item | Where | Tag | Effort | Plan |
|---|------|-------|-----|--------|------|
| O1 | Replace 10 Hz countdown busy-loop with deadline + pause/resume model | [ToastViewModel.swift:42](../../ios/ViewModels/ToastViewModel.swift#L42), [ToastManager.kt:182](../../android/src/main/java/com/margelo/nitro/nitrotoast/ToastManager.kt#L182) | 🟢 | M | _tbd_ |
| O2 | iOS: store & cancel countdown task on dismiss/update (match Android) | [ToastViewModel.swift:42](../../ios/ViewModels/ToastViewModel.swift#L42) | 🟢 | S | _tbd_ |
| O3 | Android: reuse `scope` in `checkAndRemoveContainer` (no orphan scope) | [ToastManager.kt:205](../../android/src/main/java/com/margelo/nitro/nitrotoast/ToastManager.kt#L205) | 🟢 | S | _tbd_ |
| O4 | Verify & fix pause-on-hold parity (Android lifecycle ignores `pauseMap`) | [ToastManager.kt:193](../../android/src/main/java/com/margelo/nitro/nitrotoast/ToastManager.kt#L193) | 🟢 | S | _tbd_ |
| O5 | Remove leftover `Log.d` in production path | [ToastManager.kt:188](../../android/src/main/java/com/margelo/nitro/nitrotoast/ToastManager.kt#L188) | 🟢 | XS | _tbd_ |
| O6 | iOS: derive window frame from `windowScene` (multi-window / rotation safe) — **prerequisite for iPad (T1)** | [ToastViewModel.swift:82](../../ios/ViewModels/ToastViewModel.swift#L82) | 🟢 | S | _tbd_ |
| O7 | Extract animation-offset magic number (`-300`/`0.3s`) into a named constant | both | 🟢 | XS | _tbd_ |

---

## Workstream 2 — Features

### 2a. Interface-changing (require `bun run specs` + impl on both platforms)

> Batch these into **one** codegen round to minimize bridge churn.

| # | Feature | Tag | Effort | Notes | Plan |
|---|---------|-----|--------|-------|------|
| F1 | Callbacks: `onPress`, `onShow`, `onDismiss`, `onAutoClose` | 🔴 | L | Nitro supports passing functions in config | _tbd_ |
| F2 | Action button (label + callback), e.g. "Undo" / "Retry" | 🔴 | L | Builds on F1 | _tbd_ |
| F3 | Progress bar countdown indicator | 🟢 | M | Visual duration bar | _tbd_ |

### 2b. Additive API (low risk — new method or optional field)

| # | Feature | Tag | Effort | Notes | Plan |
|---|---------|-----|--------|-------|------|
| F4 | `dismissAll()` | 🟢 | S | Currently only dismiss-by-id | _tbd_ |
| P1 | **Android stacked-mode parity** (collapsed deck + expand-on-tap) | 🟢 | M | Today Android ignores `presentation` and always renders a plain vertical `Column` ([ToastList.kt:32](../../android/src/main/java/com/margelo/nitro/nitrotoast/ToastList.kt#L32)); the iOS deck/expand behavior ([ToastStackView.swift](../../ios/Views/ToastStackView.swift)) is iOS-only. No interface change (the `'stacked'` value already exists). See notes below | _tbd_ |
| F6 | Global `configure(defaults)` for app-wide defaults | 🟢 | M | `defaultToastConfig` is exported but not settable | _tbd_ |
| F7 | `maxToasts` cap for stacked mode | 🟢 | S | Prevent unbounded growth | _tbd_ |
| F8 | Offset / inset config (custom top/bottom margin) | 🟢 | S | | _tbd_ |

#### P1 — Android stacked-mode parity: implementation notes

Additive native work, no Nitro bridge / codegen change. Reuses existing infra
(`ToastListState` StateFlow, [DraggableToast.kt](../../android/src/main/java/com/margelo/nitro/nitrotoast/DraggableToast.kt)).

1. Add `isExpanded: MutableStateFlow<Boolean>` to `ToastListState`.
2. Branch on `config.presentation` in `toastList` (mirror iOS `makeToastView`): `alert` → current vertical column; `stacked` → new `stackedToastList`.
3. `stackedToastList`: render a `Box` deck; per-toast `Modifier.graphicsLayer { scaleX/Y; translationY }` by index, animated via `animateFloatAsState`/`animateDpAsState`; tap toggles `isExpanded` (collapsed deck ↔ vertical list morph).

**iOS → Compose mapping & the one caveat:**

| iOS technique | Compose equivalent |
|---|---|
| `AnyLayout` (16+) / `matchedGeometryEffect` (15) morph | per-property `animate*AsState` on offset+scale, or `LookaheadScope` + shared-element |
| deck scale + `offsetY` by index | `graphicsLayer { scaleX/Y; translationY }` |
| tap-to-expand `isExpanded` | `MutableStateFlow<Boolean>` |
| swipe-to-dismiss | existing `DraggableToast` |
| `.ultraThinMaterial` backdrop | **blur only on API 31+** (`Modifier.blur`); fallback to a dim scrim below 31 |

> ⚠️ The true material blur backdrop is the only non-1:1 part: real blur requires
> Android 12 (API 31). Use a semi-transparent scrim as the fallback.

### 2c. Differentiators

| # | Feature | Tag | Effort | Notes | Plan |
|---|---------|-----|--------|-------|------|
| F9 | Accessibility: VoiceOver / TalkBack announcements + label | 🟢 | M | Likely missing today; high value | _tbd_ |
| F10 | Dark-mode aware default colors | 🟢 | M | Follow system color scheme | _tbd_ |
| F11 | Animation config (enter/exit type & duration) | 🟢 | M | | _tbd_ |
| F12 | RTL support | 🟢 | S | | _tbd_ |

> **Deferred (post-v2):** custom JSX content via Nitro HybridView. Large surface that
> conflicts with v2's focused-performance scope; README already points users to a JS
> lib for full layout customization. Revisit only after the perf + tablet goals land.

---

## Workstream 2d — Tablet & iPad (adaptive layout) 📱

The headline platform goal for v2: toasts should look right on large screens, not just
stretch edge-to-edge. Drives layout work across both platforms and is gated on the iOS
scene fix (O6).

| # | Item | Tag | Effort | Notes | Plan |
|---|------|-----|--------|-------|------|
| T1 | iOS iPad: max-width + horizontal centering on regular size class | 🟢 | M | Depends on O6 (windowScene). Avoid full-width stretch | _tbd_ |
| T2 | iOS iPad multi-window / Stage Manager: host toast in the active scene | 🟢 | M | Builds on O6 | _tbd_ |
| T3 | Android tablet: max-width + centering on large `WindowSizeClass` | 🟢 | M | Use `WindowMetrics` / size class | _tbd_ |
| T4 | Orientation change: keep position correct on rotate (both) | 🟢 | S | Re-evaluate frame/insets on config change | _tbd_ |
| T5 | Optional `maxWidth` config field for explicit control | 🟢 | S | Lets apps tune large-screen width | _tbd_ |

---

## Workstream 3 — Infra & quality ⚙️

Findings from the infra audit (2026-06-02). Priorities: **I4 + I1 first** (correctness/safety), then the rest.

| # | Item | Priority | Effort | Notes | Plan |
|---|------|----------|--------|-------|------|
| I1 | CI workflow: typecheck + lint + native build on every PR | 🔴 | M | No PR CI today — only `release.yml` on tag push | _tbd_ |
| I2 | Unit tests for JS layer (`showToastPromise`, config merge, loading-duration default) | 🟡 | M | | _tbd_ |
| I3 | RN version / New Architecture compatibility matrix in docs | 🟢 | S | | _tbd_ |
| I4 | Remove `postinstall: "tsc \|\| exit 0"` — it runs `tsc` in **consumers'** node_modules | 🔴 | XS | [package.json:34](../../package.json#L34); build is already handled by `prepare` (bob) | _tbd_ |
| I5 | Harden release pipeline: explicit `bun run prepare` + typecheck + lint + test gate before publish; don't rely implicitly on the `prepare` lifecycle | 🔴 | S | [release.yml](../../.github/workflows/release.yml) currently does only `bun install` → `npm-publish` | _tbd_ |
| I6 | Fix `package.json` metadata: remove non-existent `app.plugin.js` from `files`; verify/fix `specs` script (`typescript &&` likely not a valid bin → `tsc &&`) | 🟡 | XS | [package.json:29](../../package.json#L29), [package.json:41](../../package.json#L41) | _tbd_ |
| I7 | Tighten `peerDependencies` (`react`/`react-native` are `"*"`) to a supported range | 🟡 | XS | [package.json:81](../../package.json#L81) | _tbd_ |
| I8 | Release hygiene & nice-to-haves: `requireCleanWorkingDir: true`, bump `checkout@v4`/`setup-bun@v2`, `--frozen-lockfile`, `engines` field, npm `--provenance`, Android Java 17 | 🟢 | S | [.release-it.json:6](../../.release-it.json#L6), [release.yml](../../.github/workflows/release.yml), [build.gradle:113](../../android/build.gradle#L113) | _tbd_ |

---

## Proposed release sequencing

Priorities, in order: **(1) performance** → **(2) tablet/iPad** → everything else.

- **v1.x (non-breaking, ship incrementally):** I4 + I1 (infra safety, do first), O1–O7 (perf/lifecycle), F4, F7, I2, I5, I6.
- **v2.0 (tablet/iPad headline + parity):** T1–T5 + O6, **P1 (Android stacked parity)**, plus additive niceties F6, F8.
- **v2.x:** interaction (F1, F2), F3, F9–F12, I3.

> Custom JSX content (deferred) and any alert/dialog work (out of scope) are intentionally
> absent — see the **Scope decision** at the top.

---

## How to use this folder

1. Pick an item above.
2. Copy [`./plans/_TEMPLATE.md`](./plans/_TEMPLATE.md) → `./plans/<id>-<slug>.md` (e.g. `F1-callbacks.md`).
3. Fill in the plan, then link it back in the table's **Plan** column.
4. Implement following the [Nitro Interface Change Workflow](../../CLAUDE.md) and Quality Gates in `CLAUDE.md`.

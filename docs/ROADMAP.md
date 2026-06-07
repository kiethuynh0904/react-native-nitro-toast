# Roadmap

A friendly look at where **react-native-nitro-toast** is heading. This is a
direction, not a commitment — order and timing may change. Have a request? Please
[open an issue](https://github.com/kiethuynh0904/react-native-nitro-toast/issues).

> The library stays focused on **one thing done well: toasts.** Alerts/dialogs are
> intentionally out of scope. Everything planned is additive — no breaking changes.

---

## ✅ Recently shipped (v1.3.2)

- **Smoother, lighter toasts** — the auto-dismiss timer was reworked to stop waking
  up constantly, so toasts are easier on CPU and battery.
- **Hold-to-pause everywhere** — pressing and holding a toast now pauses its
  auto-dismiss on **Android** too (previously iOS only).
- A fully redesigned **example app** (playground + showcase) to try things out.

## 🚧 Coming soon

**Bigger screens**
- First-class **iPad & Android tablet** layouts — toasts sized and centered nicely
  instead of stretching edge-to-edge, with multi-window support.
- Correct behavior on rotation.

**More control**
- `dismissAll()` to clear every toast at once.
- A cap on how many stacked toasts show at a time.
- Set your **app-wide defaults** once (position, colors, duration…).
- Custom top/bottom offset.
- Matching **stacked** behavior on Android (the tap-to-expand deck, like iOS).

**Interaction**
- **Tappable toasts & action buttons** (e.g. an “Undo” button) with callbacks
  (`onPress`, `onShow`, `onDismiss`…).
- A progress bar showing the remaining time.

**Polish**
- **Accessibility**: screen-reader announcements (VoiceOver / TalkBack).
- **Dark-mode aware** default colors.
- Configurable enter/exit **animations**.
- **RTL** support.

**Docs**
- A dedicated **documentation website**.

---

## 💡 Have an idea?

Feature requests and bug reports are very welcome —
[open an issue](https://github.com/kiethuynh0904/react-native-nitro-toast/issues)
or a pull request.

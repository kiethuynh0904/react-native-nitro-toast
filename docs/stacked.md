# 🍞 Stacked Toast

> Supported on **both iOS and Android**.

The `stacked` presentation collects multiple toasts into a deck: the newest sits in
front with older ones peeking behind it. Tap the deck to expand it into a list (with a
dim backdrop); tap the backdrop to collapse.

---

## 🔧 Usage

```tsx
import { showToast } from 'react-native-nitro-toast';

showToast('First toast', {
  presentation: 'stacked',
  type: 'success',
  duration: 0,
});

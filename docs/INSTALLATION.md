# 📋 Requirements

> This package uses [NitroModules](https://nitro.margelo.com/).  
> Please ensure your setup meets the [minimum requirements](https://nitro.margelo.com/docs/minimum-requirements).

**System Requirements**
- React Native: **≥ 0.75.0**
- iOS: **Xcode ≥ 16.0**
- Android: **Kotlin ≥ 2.0.0**

---

# 📦 Installation

### 1. Install Peer Dependencies

```sh
yarn add react-native-nitro-modules
```

### 2. Install This Package

```sh
yarn add react-native-nitro-toast
```

### 3. Install iOS Dependencies

```sh
cd ios && pod install && cd ..
```

### 4. (Optional) Enable Haptics on Android

Add the following permission to your `AndroidManifest.xml` if you want haptic feedback:

```xml
<uses-permission android:name="android.permission.VIBRATE" />
```

---

Continue with the [Quick Start](../README.md#-quick-start) in the main README.

---

# 🧑‍💻 Expo Setup
### 1. Install Expo Modules

```sh
npx expo install react-native-nitro-modules react-native-nitro-toast
```

### 2. Prebuild Your Project (if not already)

```sh
npx expo prebuild
```

### 3. Run on a Custom Development Client

```sh
npx expo run:android
# or
npx expo run:ios
```

### 4. (Optional) Enable Haptics on Android

Add the following permission to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.VIBRATE" />
```
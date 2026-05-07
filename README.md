<p align="center">
  <img src="https://img.shields.io/badge/flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-brightgreen?style=for-the-badge" alt="Platform"/>
</p>

<br/>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue?style=flat-square" alt="Version"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License"/>
  <img src="https://img.shields.io/badge/build-passing-brightgreen?style=flat-square" alt="Build Status"/>
</p>

<h1 align="center">🏠 HomeTec</h1>
<p align="center"><em>Smart Home Control at Your Fingertips</em></p>

<p align="center">
  A cross-platform Flutter application for managing smart home devices with an intuitive interface, 
  dark mode, multi-language support, and offline-first local storage.
</p>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🌓 **Dark Mode** | Toggle between light and dark themes with persistent preference |
| 🌐 **Multi-Language** | English, Spanish, French, Arabic, Chinese — with instant switching |
| 🔐 **Authentication Flow** | Splash → Login → Social sign-in → Password reset (all simulated locally) |
| 👤 **Profile Management** | Edit name, email, phone; upload profile photo via camera/gallery |
| ⚡ **Quick Modes** | One-tap scenes: Home, Away, Sleep, Gym, Party |
| ⭐ **Favorites** | Toggle frequently used devices on/off from a dedicated grid |
| 🚪 **Room Management** | Add/remove rooms, control lights and appliances per room |
| 📊 **Energy Dashboard** | View energy usage chart and room statistics |
| 🔒 **Offline-First** | All data persisted locally via `SharedPreferences` — no backend required |

---

## 📱 Screens

| Screen | Purpose |
|--------|---------|
| `SplashScreen` | Animated splash with auto-navigation |
| `LoginScreen` | Email/password login with validation |
| `SocialLoginScreen` | Face, Twitter/X, and Google login simulation |
| `ForgotPasswordScreen` | Email input for password reset |
| `VerificationCodeScreen` | 4-digit code verification with resend timer |
| `NewPasswordScreen` | Set new password with confirmation |
| `ConfirmMailScreen` | Success confirmation screen |
| `HomeScreen` | Main hub — quick modes, system status, favorites grid |
| `FavoriteScreen` | Full grid of favorite devices with toggles |
| `RoomsStatsScreen` | Room cards with swipe-to-delete, device toggles, energy chart |
| `AddRoomScreen` | Form to add a new room |
| `ProfileScreen` | Edit profile, upload photo, logout |
| `SettingsScreen` | Dark mode toggle, language selector |

---

## 🧱 Architecture

```
lib/
├── main.dart                  # App entry, theme/locale state management
├── models/
│   └── user_model.dart        # User data model
├── screens/                   # 13 feature screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── social_login_screen.dart
│   ├── forgot_password_screen.dart
│   ├── verification_code_screen.dart
│   ├── new_password_screen.dart
│   ├── confirm_mail_screen.dart
│   ├── home_screen.dart
│   ├── favorite_screen.dart
│   ├── rooms_stats_screen.dart
│   ├── add_room_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── utils/
│   ├── app_colors.dart        # Centralized color palette
│   ├── app_state.dart         # Global state management
│   └── shared_prefs_helper.dart  # Local storage layer
└── widgets/
    ├── bottom_nav_bar.dart    # Custom bottom navigation
    ├── custom_button.dart     # Reusable styled button
    └── room_card.dart         # Room status card widget
```

---

## 🎨 Color Palette

| Token | Color | Hex |
|-------|-------|-----|
| Primary | ![#C26F4B](https://via.placeholder.com/12/C26F4B/000000?text=+) | `#C26F4B` |
| Background | ![#F8FAFC](https://via.placeholder.com/12/F8FAFC/000000?text=+) | `#F8FAFC` |
| Text Dark | ![#0F172A](https://via.placeholder.com/12/0F172A/000000?text=+) | `#0F172A` |
| Text Medium | ![#475569](https://via.placeholder.com/12/475569/000000?text=+) | `#475569` |
| Switch Green | ![#10B981](https://via.placeholder.com/12/10B981/000000?text=+) | `#10B981` |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`

### Installation

```bash
# Clone the repository
git clone https://github.com/Alaashamel/tec_home.git
cd tec_home

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release

# Web
flutter build web
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | UI framework |
| `shared_preferences` | ^2.2.2 | Persistent local storage |
| `image_picker` | ^1.0.4 | Profile photo upload |
| `path_provider` | ^2.1.1 | File system paths |
| `flutter_localizations` | SDK | Multi-language support |

---

## 🧪 Running Tests

```bash
flutter test
```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  Built with ❤️ using <a href="https://flutter.dev">Flutter</a>
</p>

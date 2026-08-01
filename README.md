# Rivermouth Scheduler

Offline-first employee scheduling app for Rivermouth Beach Bar, built with Flutter (Material 3, Hive, Provider). Optional online sync via Firebase keeps multiple devices up to date when connected.

## Features
- Admin PIN required for edit actions (add/edit/delete employee, change shift, Settings) — the app opens straight to a view-only home
- Employee management (add / edit / delete, duplicate-name protection)
- Departments — Waiter, Bar, Kitchen, Admin — with filter chips on Employees and Schedule
- Weekly schedule grid — tap a cell to assign Morning (M) / Middle (Md) / Afternoon (A) / Off
- PDF export grouped by department, color-coded, with OFF/Middle always shown in red/blue
- Share the schedule PDF via WhatsApp or any installed share target
- Offline-first — all data stored locally with Hive; works fully with zero internet
- **Optional online sync (Firebase)** — when configured and online, changes sync automatically across every device signed into the same Firebase project

## Getting started
```
flutter create .      # generates android/ios/web platform folders
flutter pub get
flutter run
```

## Enabling online sync (optional)

The app works completely offline without this. To sync data across multiple phones/devices:

1. Install the Firebase CLI and FlutterFire CLI:
   ```
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
2. Log in and create a Firebase project (free "Spark" plan is enough):
   ```
   firebase login
   ```
   Then create a project at https://console.firebase.google.com (or `firebase projects:create`).
3. Enable **Firestore Database** in the Firebase console (Build → Firestore Database → Create database → start in test mode, or set proper security rules for production).
4. From this project's root folder, run:
   ```
   flutterfire configure
   ```
   Select your project and platforms (Android/iOS). This overwrites `lib/firebase_options.dart` with your real project keys and downloads `android/app/google-services.json` (and `ios/Runner/GoogleService-Info.plist` for iOS).
5. Rebuild the app. That's it — `main.dart` already initializes Firebase and every provider already pushes/listens for changes.

**Note:** the placeholder `lib/firebase_options.dart` committed in this repo is non-functional on purpose — until you run `flutterfire configure`, Firebase init fails silently and the app just runs offline-only (no crash, no visible error).

### Security rules
The default Firestore "test mode" allows anyone to read/write, which is fine for trying this out but **not for production**. Before real use, lock it down in the Firebase console (Firestore → Rules), e.g. requiring Firebase Auth, or at minimum restrict to your own IP/App Check.

## Architecture
```
lib/
  core/        constants, theme, small utils
  data/        Hive models, box init, repositories (Employee, Schedule)
  providers/   ChangeNotifier state: Auth, Employee, Schedule, Settings
  services/    PDF generation, share sheet, Firestore sync
  screens/     employees, schedule, settings (each with its own widgets/)
  widgets/     shared widgets (department filter, PIN prompt dialog)
```

## Tests
```
flutter test
```
Covers `ShiftType`, the local ID generator, and `AuthProvider` PIN logic.

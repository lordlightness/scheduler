# Rivermouth Scheduler

Offline-first employee scheduling app for Rivermouth Beach Bar, built with Flutter (Material 3, Hive, Provider).

## Features
- Admin PIN login (PIN stored locally via Hive, changeable in Settings)
- Employee management (add / edit / delete, duplicate-name protection)
- Monthly schedule grid — tap a cell to assign Morning (M) / Middle (Md) / Afternoon (A) / Off
- PDF export of the monthly schedule
- Share the schedule PDF via WhatsApp or any installed share target
- Fully offline — all data stored locally with Hive

## Getting started
```
flutter create .      # generates android/ios/web platform folders
flutter pub get
flutter run
```

## Architecture
```
lib/
  core/        constants, theme, small utils
  data/        Hive models, box init, repositories (Employee, Schedule)
  providers/   ChangeNotifier state: Auth, Employee, Schedule, Settings
  services/    PDF generation, share sheet
  screens/     login, employees, schedule, settings (each with its own widgets/)
```

## Tests
```
flutter test
```
Covers `ShiftType`, the local ID generator, and `AuthProvider` PIN logic.

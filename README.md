# lead_manager

## Stack used
- Flutter (Material 3)
- Dart
- Hive + hive_flutter (local persistence)
- shared_preferences (login state)
- flutter_slidable (swipe actions)
- State management via `ValueListenableBuilder` with Hive listenables

## App flow
1. Splash Screen
    1. Starting point of the app
    2. Checks wether the user is logged in or not
    3. If Logged in navigates to leads listing screen
    4. Else navigates to login screen
2. Login Screen
    1. Authentication Screen
    2. Takes username and password to authenticated (admin/admin hardcoded)
    3. After successful login navigates to leads list screen
    4. Else shows error message in a snack bar.
3. Leads Listing Screen
    1. Loads leads from Hive
    2. Supports search by name, email, phone, or service
    3. Edit and delete actions via right to left swipe on a lead
4. Lead Form Screen
    1. Add new lead or edit existing lead
    2. Validates inputs and saves to Hive

## Improvements with more time
1. Considering a solid Statement solution Preferrably BLoC.
2. Lean more towars Clean Coding architecture adding remote source, repository and service layers
3. Migrate to cloud database for online uses (like supabase, firebase) and sync, backups, and conflict handling.
4. Create proper authenticaion using firebase auth, OAuths etc.

## Run the app
1. Install Flutter and set up your environment.
2. From the project root, get dependencies:
```bash
flutter pub get
```
3. Run on a connected device/emulator:
```bash
flutter run
```

## Build APK
```bash
flutter build apk
```

## Build App Bundle (AAB)
```bash
flutter build appbundle
```

# J'Donuts Flutter app

A local-data Flutter demo for customer onboarding, product browsing, and rewards.

## Requirements and run

- Flutter **3.47.9** (stable)
- Dart **3.13.7**
- Android SDK / Xcode for the respective mobile target

```sh
flutter pub get
flutter run
```

The fake OTP is `123456`. Registration, login, and session restoration use local
storage and do not require a backend.

## Architecture

The app uses **BLoC/Cubit** for authentication and registration state, **GetIt**
for dependency injection, **go_router** for navigation and authenticated routes,
and **Drift/SQLite** for persistent app data.

```text
lib/
  core/                 Theme tokens, motion, shared widgets, connectivity
  database/             Drift schema, migrations, DAOs, bundled seed loader
  di/                   GetIt registrations
  features/
    auth/               Auth data, domain, and presentation
    home/               Home presentation and SQLite catalog data access
    members/            Member domain and tier progress
    products/            Product detail presentation
    rewards/             Rewards presentation and painters
  l10n/                 English and Burmese ARB translations
assets/seed/             Bundled catalog, shops, tiers, challenges, and banners
test/                    Unit and widget tests
integration_test/        Register → Home → Product detail flow
```

## Offline data and images

Bundled JSON seeds the local SQLite database on first launch. Home sections,
product details, member information, and Rewards read from the local database.
Bundled image assets cover the seeded catalog; network images use a disk cache
with loading and error placeholders. A connectivity status plus an internet
reachability probe displays an offline banner. Pull-to-refresh and regaining
connectivity reload the local source of truth.

There is no remote catalog API in this demo, so refresh does not download changed
catalog data.

## Motion

Motion durations and curves are centralized in `lib/core/theme/app_motion.dart`.
Onboarding and auth steps enter with staggered motion; registration progress,
buttons, and OTP errors animate; Home sections and banners animate; product
images use Hero transitions and quantity updates animate; Rewards animates its
entry and progress displays. Motion is reduced when the system's Reduce Motion
setting is enabled.

## Localization

English (`en`) and Burmese (`my`) are available. Change languages from the
Settings sheet in the bottom navigation.

## Verification

```sh
flutter analyze
flutter test
flutter test integration_test/register_home_product_test.dart -d <device-id>
```

Build artifacts for submission:

```sh
flutter build apk --release
flutter build ios --simulator --debug
ditto -c -k --sequesterRsrc --keepParent \
  build/ios/iphonesimulator/Runner.app build/ios/iphonesimulator/Runner.app.zip
```

## Known gaps and submission notes

- Authentication, social sign-in, and cart behavior are demo/local implementations.
- No remote server is configured; catalog refresh is local-only.
- Actual implementation time was 24 hours.

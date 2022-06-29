# dart_supabase_example

An example that uses the Supabase's Dart library rather than their Flutter library to authorize a signed up user and persist the session data locally.

## To run this locally you will need to

- install the required packages via `flutter pub get`
- create a project on [Supabase](https://supabase.com/) a Firebase alternative
- register a userID (email) and password for some user
- save your Supabase project URL and Anonymous API Key to `assets/secrets.json`
- the registered user credentials can also be stored in the `assets/secrets.json`

## Design Notes

All globally available services are stored in state store via `provider`.

Secrets are loaded as asset data from `assets/secrets.json`.

Session data is persisted via `shared_preferences`.

Toasts are shown via the newer [`scaffoldMessengerKey` pattern](https://docs.flutter.dev/release/breaking-changes/scaffold-messenger) via an object managed by the app's store.

## Notes

This project has only been tested on virtualized Android hardware. No setup has been done to enable the installed packages to work on other platforms.

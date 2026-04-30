# Development Notes

## Architecture

The app follows a simple layered structure:
- **Screens** handle UI and user interaction only
- **Services** are stateless/singleton helpers for external concerns (API, storage, notifications, fraud)
- **Models** are plain Dart classes with `fromJson` factories

No state management library is used — `setState` is sufficient for the current scope. If the app grows, consider `Riverpod` or `Bloc`.

---

## Known Limitations

### Windows Developer Mode (symlinks)
Running `flutter pub get` on Windows may exit with code 1 and warn:
```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```
This does **not** break the app. Enable Developer Mode via `start ms-settings:developers` to silence it, or just run on an Android device/emulator where it has no effect.

### Fraud Detection is in-memory only
`FraudDetector` resets when the app is killed. For a real system, timestamps should be persisted and checked server-side.

### No real authentication
Login accepts any non-empty username/password. In production, replace with a proper auth flow (JWT, OAuth, etc.).

### Notification permission (Android 13+)
`POST_NOTIFICATIONS` is declared in `AndroidManifest.xml` and requested at runtime via `requestNotificationsPermission()`. If the user denies it, bids still work — only the system notification is silently skipped.

---

## API

Products are fetched from the public [Fake Store API](https://fakestoreapi.com):

```
GET https://fakestoreapi.com/products
```

Only `title`, `price`, and `image` fields are mapped. The full response includes `id`, `description`, `category`, and `rating` which can be added to `Product` model if needed.

---

## Adding More Features

- **Search/filter** — add a search bar to `ProductsScreen` filtering the in-memory list
- **Bid history** — store a `List<String>` in `SharedPreferences` instead of just the last bid
- **Dark mode** — `ThemeData` already uses `ColorScheme.fromSeed`; add `darkTheme` to `MaterialApp`
- **Real backend** — swap `ProductService` and `PrefsService` with API calls and token storage

# Tradix

Tradix is a Flutter stock market app with a finance-style UI, light and dark themes, authentication, market screens, portfolio management, and profile settings.

## Features

- Email and password authentication
- Registration and sign in
- Password reset flow with deep links
- Home, Markets, Portfolio, Profile, Buy Pro, and stock detail screens
- Editable personal information
- Logout and account deletion
- Currency display for stock values
- Light and dark theme support
- Custom launcher icons for Android and iOS

## Environment Configuration

This project uses environment variables for sensitive values and API configuration.

Create a local `.env` file in the project root and add the required values there.


## Getting Started

1. Install dependencies with `flutter pub get`.
2. Add the required app configuration and API keys.
3. Run the app with `flutter run`.

## Project Structure

- `lib/main.dart` - app entry point and routing
- `lib/screens/` - app screens
- `lib/shared/` - shared colors, widgets, and theme helpers
- `lib/services/` - app services and data handling

## Notes

- Do not commit secret keys or private credentials.
- Commit launcher icon files and platform configuration files when branding changes.
- Keep shared theme values synchronized so light and dark mode behave consistently.
- Make sure deep links are configured for password recovery.

## Status

This project is actively being developed.

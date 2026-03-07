# in_app_updation_plugin

A Flutter plugin for in-app APK updates on Android. Check for updates from your remote API and install new APKs automatically.

**Supported platforms:** Android (full support). iOS (placeholder).

## Features

- Call update API and compare build numbers
- Show update dialog with optional force update
- Download APK with Dio
- Install APK via Android native code (FileProvider)
- Plug-and-play integration

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  in_app_updation_plugin: ^0.0.1
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:in_app_updation_plugin/in_app_updation_plugin.dart';

// In your widget:
ElevatedButton(
  onPressed: () => AutoUpdater.checkForUpdate(
    context: context,
    config: UpdateConfig(
      apiUrl: "https://your-api.com/app/update",
    ),
  ),
  child: Text('Check for Update'),
)
```

## API Response Format

Your update API should return JSON in this format:

```json
{
  "version": "1.0.2",
  "build_number": 4,
  "force_update": true,
  "apk_url": "https://cdn.example.com/app.apk",
  "message": "New features available"
}
```

| Field        | Type    | Required | Description                                      |
|--------------|---------|----------|--------------------------------------------------|
| version      | string  | No       | Version string (e.g., "1.0.2")                   |
| build_number | number  | Yes      | Used for comparison with current app build       |
| force_update | boolean | No       | If true, user cannot dismiss the update dialog   |
| apk_url      | string  | Yes      | URL to download the APK                          |
| message      | string  | No       | Message shown in the update dialog               |

The plugin compares `build_number` with your app's build number from `package_info_plus`. If the API returns a higher build number, the update dialog is shown.

## Configuration

```dart
UpdateConfig(
  apiUrl: "https://example.com/app/update",  // Required
  showDialog: true,  // Optional, default: true. Set false for custom UI.
)
```

## Android Setup

The plugin automatically adds:
- `REQUEST_INSTALL_PACKAGES` permission
- `WRITE_EXTERNAL_STORAGE` (for Android ≤ 9)
- FileProvider for secure APK installation (Android 7+)

Ensure your app's `build_number` in `pubspec.yaml` is set correctly, as it's used for version comparison.

## Example & Local Testing

See the `example/` folder for a complete demo app.

**Local test API** (minimal Node server):

```bash
cd test_api
npm install
npm start
```

Then build the example APK, copy it for serving, and run the app:

```bash
cd example && flutter build apk
cp build/app/outputs/flutter-apk/app-release.apk ../test_api/app.apk
flutter run
```

The example is preconfigured to use `http://10.0.2.2:3000/app/update` (Android emulator). For a physical device, set `HOST=<your-ip>` and update the apiUrl in the example.

## License

See the [LICENSE](LICENSE) file.

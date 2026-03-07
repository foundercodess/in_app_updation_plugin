import 'package:flutter/material.dart';

import 'in_app_updation_plugin_platform_interface.dart';
import 'src/auto_updater.dart';
import 'src/update_config.dart';

export 'src/update_config.dart';
export 'src/update_model.dart';

/// In-app auto-updater for Flutter apps.
///
/// Call [checkForUpdate] to check for updates from your remote API
/// and optionally show an update dialog.
///
/// Example:
/// ```dart
/// AutoUpdater.checkForUpdate(
///   context: context,
///   config: UpdateConfig(
///     apiUrl: "https://example.com/app/update",
///   ),
/// );
/// ```
///
/// **Supported platforms:** Android (APK installation). iOS is a placeholder.
class AutoUpdater {
  AutoUpdater._();

  /// Returns the platform version string. Useful for debugging.
  static Future<String?> getPlatformVersion() {
    return InAppUpdationPluginPlatform.instance.getPlatformVersion();
  }

  /// Checks for updates from the configured API and shows the update dialog
  /// if a newer version is available.
  ///
  /// The API should return JSON in this format:
  /// ```json
  /// {
  ///   "version": "1.0.2",
  ///   "build_number": 4,
  ///   "force_update": true,
  ///   "apk_url": "https://cdn.example.com/app.apk",
  ///   "message": "New features available"
  /// }
  /// ```
  static Future<void> checkForUpdate({
    required BuildContext context,
    required UpdateConfig config,
  }) async {
    await AutoUpdaterImpl.checkForUpdate(context: context, config: config);
  }
}

/// Legacy class for backwards compatibility. Use [AutoUpdater] instead.
@Deprecated('Use AutoUpdater instead')
class InAppUpdationPlugin {
  InAppUpdationPlugin();

  Future<String?> getPlatformVersion() {
    return InAppUpdationPluginPlatform.instance.getPlatformVersion();
  }
}

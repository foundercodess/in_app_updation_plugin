import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../in_app_updation_plugin_platform_interface.dart';
import 'apk_downloader.dart';
import 'update_config.dart';
import 'update_dialog.dart';
import 'update_model.dart';
import 'update_service.dart';

/// Core implementation of the auto-update flow.
class AutoUpdaterImpl {
  static bool _isChecking = false;

  /// Checks for updates and shows the update dialog if a newer version is available.
  static Future<void> checkForUpdate({
    required BuildContext context,
    required UpdateConfig config,
  }) async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final update = await UpdateService.checkForUpdate(config);

      if (!context.mounted) return;

      if (update == null) {
        _isChecking = false;
        return;
      }

      if (config.showDialog) {
        showUpdateDialog(
          context: context,
          update: update,
          onUpdate: () => _performUpdate(context, update),
          onLater: () => _isChecking = false,
        );
      }
    } on UpdateServiceException catch (e) {
      _isChecking = false;
      if (context.mounted) {
        _showError(context, e.message);
      }
    } catch (e) {
      _isChecking = false;
      if (context.mounted) {
        _showError(context, 'Failed to check for updates. Please try again.');
      }
    }
  }

  static Future<void> _performUpdate(BuildContext context, UpdateModel update) async {
    try {
      if (!context.mounted) return;

      // Request install permission on Android 8+
      if (Platform.isAndroid) {
        final status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          if (context.mounted) {
            _showError(
              context,
              'Install permission is required to update the app.',
            );
          }
          return;
        }
      }

      if (!context.mounted) return;

      final apkPath = await ApkDownloader.download(
        update.apkUrl,
        onProgress: (received, total) {
          // Progress can be used for UI in future
        },
      );

      await InAppUpdationPluginPlatform.instance.installApk(apkPath);
    } on ApkDownloadException catch (e) {
      _isChecking = false;
      if (context.mounted) {
        _showError(context, e.message);
      }
    } catch (e) {
      _isChecking = false;
      if (context.mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        _showError(
          context,
          msg.length > 80 ? 'Failed to install update. Please try again.' : msg,
        );
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

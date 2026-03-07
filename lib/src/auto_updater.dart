import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
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
    if (_isChecking) {
      debugPrint('[in_app_updation] Check already in progress, skipping');
      return;
    }
    _isChecking = true;
    debugPrint('[in_app_updation] checkForUpdate started');

    try {
      final update = await UpdateService.checkForUpdate(config);

      if (!context.mounted) return;

      if (update == null) {
        debugPrint('[in_app_updation] No update available');
        return;
      }

      debugPrint('[in_app_updation] Showing update dialog for ${update.version}');
      if (config.showDialog) {
        showUpdateDialog(
          context: context,
          update: update,
          onUpdate: () => _performUpdate(context, update),
          onLater: () => _isChecking = false,
        );
      }
    } on UpdateServiceException catch (e) {
      debugPrint('[in_app_updation] UpdateServiceException: $e');
      _isChecking = false;
      if (context.mounted) {
        _showError(context, e.message);
      }
    } on DioException catch (e) {
      debugPrint('[in_app_updation] DioException: ${e.type} ${e.message}');
      _isChecking = false;
      if (context.mounted) {
        _showError(context,
            'Network error. Check your connection and try again.');
      }
    } on TimeoutException catch (e) {
      debugPrint('[in_app_updation] TimeoutException: $e');
      _isChecking = false;
      if (context.mounted) {
        _showError(context, 'Request timed out. Please try again.');
      }
    } catch (e) {
      debugPrint('[in_app_updation] Check failed: $e');
      _isChecking = false;
      if (context.mounted) {
        _showError(context, 'Failed to check for updates. Please try again.');
      }
    }
  }

  static Future<void> _performUpdate(BuildContext context, UpdateModel update) async {
    debugPrint('[in_app_updation] _performUpdate started for ${update.version}');
    try {
      if (!context.mounted) return;

      if (Platform.isAndroid) {
        debugPrint('[in_app_updation] Requesting install permission');
        final status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          debugPrint('[in_app_updation] Install permission denied');
          if (context.mounted) {
            _showError(
              context,
              'Install permission is required to update the app.',
            );
          }
          return;
        }
        debugPrint('[in_app_updation] Install permission granted');
      }

      if (!context.mounted) return;

      final apkPath = await ApkDownloader.download(
        update.apkUrl,
        onProgress: (received, total) {
          // Progress logged in ApkDownloader
        },
      );

      debugPrint('[in_app_updation] Triggering install: $apkPath');
      await InAppUpdationPluginPlatform.instance.installApk(apkPath);
      debugPrint('[in_app_updation] Install intent sent successfully');
    } on ApkDownloadException catch (e) {
      debugPrint('[in_app_updation] ApkDownloadException: $e');
      _isChecking = false;
      if (context.mounted) {
        _showError(context, e.message);
      }
    } catch (e) {
      debugPrint('[in_app_updation] Install failed: $e');
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

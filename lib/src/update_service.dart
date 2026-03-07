import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'update_config.dart';
import 'update_model.dart';

/// Service that fetches update information from the remote API
/// and compares with the current app version.
class UpdateService {
  static final Dio _dio = Dio();

  /// Fetches update info from [config.apiUrl] and returns [UpdateModel]
  /// if a newer version is available, otherwise returns null.
  ///
  /// Throws [DioException] on API/network failure.
  static Future<UpdateModel?> checkForUpdate(UpdateConfig config) async {
    debugPrint('[in_app_updation] Checking for update: ${config.apiUrl}');

    final packageInfo = await PackageInfo.fromPlatform();
    final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
    debugPrint(
        '[in_app_updation] Current: version=${packageInfo.version} build=$currentBuildNumber');

    final response = await _dio.get<Map<String, dynamic>>(config.apiUrl);
    debugPrint('[in_app_updation] API response: status=${response.statusCode}');

    if (response.data == null) {
      debugPrint('[in_app_updation] No data in response, skipping update');
      return null;
    }

    final update = UpdateModel.fromJson(response.data!);
    debugPrint(
        '[in_app_updation] Remote: version=${update.version} build=${update.buildNumber}');

    if (update.buildNumber <= currentBuildNumber) {
      debugPrint(
          '[in_app_updation] No update needed (remote ${update.buildNumber} <= current $currentBuildNumber)');
      return null;
    }

    if (update.apkUrl.isEmpty) {
      debugPrint('[in_app_updation] Error: APK URL is empty');
      throw UpdateServiceException('Invalid APK URL');
    }

    debugPrint('[in_app_updation] Update available: ${update.version}');
    return update;
  }
}

/// Exception thrown when the update service encounters an error.
class UpdateServiceException implements Exception {
  final String message;
  UpdateServiceException(this.message);

  @override
  String toString() => 'UpdateServiceException: $message';
}

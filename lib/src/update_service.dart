import 'package:dio/dio.dart';
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
    final packageInfo = await PackageInfo.fromPlatform();
    final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

    final response = await _dio.get<Map<String, dynamic>>(config.apiUrl);

    if (response.data == null) {
      return null;
    }

    final update = UpdateModel.fromJson(response.data!);

    if (update.buildNumber <= currentBuildNumber) {
      return null;
    }

    if (update.apkUrl.isEmpty) {
      throw UpdateServiceException('Invalid APK URL');
    }

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

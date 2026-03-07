import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Handles downloading the APK file from a remote URL.
class ApkDownloader {
  static final Dio _dio = Dio();

  /// Downloads the APK from [url] and saves it to the app documents directory.
  ///
  /// Returns the local file path of the downloaded APK.
  /// [onProgress] is called with (received, total) bytes during download.
  ///
  /// Throws [DioException] on download failure.
  static Future<String> download(
    String url, {
    void Function(int received, int total)? onProgress,
  }) async {
    // Use cache directory - reliably mapped in Android FileProvider
    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/update.apk';

    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      options: Options(
        followRedirects: true,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final file = File(savePath);
    if (!await file.exists()) {
      throw ApkDownloadException('Download failed: file not found');
    }

    return savePath;
  }
}

/// Exception thrown when APK download fails.
class ApkDownloadException implements Exception {
  final String message;
  ApkDownloadException(this.message);

  @override
  String toString() => 'ApkDownloadException: $message';
}

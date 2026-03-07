import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('[in_app_updation] Downloading APK: $url');

    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/update.apk';
    debugPrint('[in_app_updation] Save path: $savePath');

    await _dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          final pct = (received / total * 100).toStringAsFixed(1);
          debugPrint('[in_app_updation] Download progress: $pct% ($received/$total)');
        }
        onProgress?.call(received, total);
      },
      options: Options(
        followRedirects: true,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final file = File(savePath);
    if (!await file.exists()) {
      debugPrint('[in_app_updation] Download failed: file not found at $savePath');
      throw ApkDownloadException('Download failed: file not found');
    }

    final size = await file.length();
    debugPrint('[in_app_updation] Download complete: $savePath (${size ~/ 1024} KB)');
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

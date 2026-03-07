/// Model representing the update information from the remote API.
///
/// Expected API response format:
/// ```json
/// {
///   "version": "1.0.2",
///   "build_number": 4,
///   "force_update": true,
///   "apk_url": "https://cdn.example.com/app.apk",
///   "message": "New features available"
/// }
/// ```
class UpdateModel {
  /// The version string (e.g., "1.0.2").
  final String version;

  /// The build number used for version comparison.
  final int buildNumber;

  /// If true, the user cannot dismiss the update dialog.
  final bool forceUpdate;

  /// The URL to download the APK.
  final String apkUrl;

  /// Optional message to display in the update dialog.
  final String message;

  const UpdateModel({
    required this.version,
    required this.buildNumber,
    required this.forceUpdate,
    required this.apkUrl,
    required this.message,
  });

  /// Creates an [UpdateModel] from a JSON map.
  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      version: json['version'] as String? ?? '',
      buildNumber: (json['build_number'] as num?)?.toInt() ?? 0,
      forceUpdate: json['force_update'] as bool? ?? false,
      apkUrl: json['apk_url'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

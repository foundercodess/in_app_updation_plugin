/// Configuration for the in-app update check.
///
/// Use [apiUrl] to specify the endpoint that returns update information.
/// Set [showDialog] to false to handle update UI manually.
class UpdateConfig {
  /// The API URL that returns update information in the expected format.
  final String apiUrl;

  /// Whether to automatically show the update dialog when an update is available.
  /// Defaults to true. Set to false for custom UI handling.
  final bool showDialog;

  /// Optional delay before showing the update dialog. Helps avoid memory spikes
  /// on some devices (e.g. when Flutter/Impeller is under load). Default: 300ms.
  final Duration? dialogDelay;

  const UpdateConfig({
    required this.apiUrl,
    this.showDialog = true,
    this.dialogDelay,
  });
}

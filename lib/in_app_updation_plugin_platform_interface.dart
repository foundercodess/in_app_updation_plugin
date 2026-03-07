import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'in_app_updation_plugin_method_channel.dart';

abstract class InAppUpdationPluginPlatform extends PlatformInterface {
  /// Constructs a InAppUpdationPluginPlatform.
  InAppUpdationPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static InAppUpdationPluginPlatform _instance = MethodChannelInAppUpdationPlugin();

  /// The default instance of [InAppUpdationPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelInAppUpdationPlugin].
  static InAppUpdationPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InAppUpdationPluginPlatform] when
  /// they register themselves.
  static set instance(InAppUpdationPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Triggers APK installation on Android. No-op on other platforms.
  Future<void> installApk(String apkPath) {
    throw UnimplementedError('installApk() has not been implemented.');
  }
}

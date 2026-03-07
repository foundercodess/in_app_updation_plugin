import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'in_app_updation_plugin_platform_interface.dart';

/// An implementation of [InAppUpdationPluginPlatform] that uses method channels.
class MethodChannelInAppUpdationPlugin extends InAppUpdationPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('in_app_updation_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> installApk(String apkPath) async {
    await methodChannel.invokeMethod<void>('installApk', {
      'apkPath': apkPath,
    });
  }
}

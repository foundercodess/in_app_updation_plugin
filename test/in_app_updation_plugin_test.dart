import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_updation_plugin/in_app_updation_plugin.dart';
import 'package:in_app_updation_plugin/in_app_updation_plugin_platform_interface.dart';
import 'package:in_app_updation_plugin/in_app_updation_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInAppUpdationPluginPlatform
    with MockPlatformInterfaceMixin
    implements InAppUpdationPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> installApk(String apkPath) => Future.value();
}

void main() {
  final InAppUpdationPluginPlatform initialPlatform = InAppUpdationPluginPlatform.instance;

  test('$MethodChannelInAppUpdationPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInAppUpdationPlugin>());
  });

  test('getPlatformVersion', () async {
    InAppUpdationPlugin inAppUpdationPlugin = InAppUpdationPlugin();
    MockInAppUpdationPluginPlatform fakePlatform = MockInAppUpdationPluginPlatform();
    InAppUpdationPluginPlatform.instance = fakePlatform;

    expect(await inAppUpdationPlugin.getPlatformVersion(), '42');
  });
}

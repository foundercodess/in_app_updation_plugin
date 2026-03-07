import Flutter
import UIKit

public class InAppUpdationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "in_app_updation_plugin", binaryMessenger: registrar.messenger())
    let instance = InAppUpdationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "installApk":
      // APK installation is Android only. No-op on iOS.
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

#ifndef FLUTTER_PLUGIN_IN_APP_UPDATION_PLUGIN_H_
#define FLUTTER_PLUGIN_IN_APP_UPDATION_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace in_app_updation_plugin {

class InAppUpdationPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  InAppUpdationPlugin();

  virtual ~InAppUpdationPlugin();

  // Disallow copy and assign.
  InAppUpdationPlugin(const InAppUpdationPlugin&) = delete;
  InAppUpdationPlugin& operator=(const InAppUpdationPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace in_app_updation_plugin

#endif  // FLUTTER_PLUGIN_IN_APP_UPDATION_PLUGIN_H_

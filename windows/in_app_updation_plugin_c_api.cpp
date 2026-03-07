#include "include/in_app_updation_plugin/in_app_updation_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "in_app_updation_plugin.h"

void InAppUpdationPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  in_app_updation_plugin::InAppUpdationPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

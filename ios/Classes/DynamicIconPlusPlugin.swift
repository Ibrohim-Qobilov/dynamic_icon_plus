import Flutter
import UIKit

public class DynamicIconPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dynamic_icon_plus", binaryMessenger: registrar.messenger())
    let instance = DynamicIconPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "supportsAlternateIcons":
      if #available(iOS 10.3, *) {
        result(UIApplication.shared.supportsAlternateIcons)
      } else {
        result(false)
      }

    case "getAlternateIconName":
      if #available(iOS 10.3, *) {
        result(UIApplication.shared.alternateIconName)
      } else {
        result(nil)
      }

    case "getAvailableIcons":
      var iconNames: [String] = []
      if let bundleIcons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
         let alternateIcons = bundleIcons["CFBundleAlternateIcons"] as? [String: Any] {
        iconNames = Array(alternateIcons.keys)
      }
      result(iconNames)

    case "setAlternateIconName":
      guard #available(iOS 10.3, *) else {
        result(FlutterError(code: "UNSUPPORTED_OS", message: "Dynamic icons require iOS 10.3 or higher", details: nil))
        return
      }

      guard UIApplication.shared.supportsAlternateIcons else {
        result(FlutterError(code: "NOT_SUPPORTED", message: "Alternate icons not supported on this device", details: nil))
        return
      }

      let args = call.arguments as? [String: Any]
      let iconName = args?["iconName"] as? String
      let showAlert = args?["showAlert"] as? Bool ?? true

      DispatchQueue.main.async {
        if !showAlert {
          // If showAlert is false, attempt to suppress the system modal dialog via selector if available
          let selector = NSSelectorFromString("_setAlternateIconName:completionHandler:")
          if UIApplication.shared.responds(to: selector) {
            UIApplication.shared.perform(selector, with: iconName, with: { (error: Error?) in
              if let error = error {
                result(FlutterError(code: "SET_ICON_FAILED", message: error.localizedDescription, details: nil))
              } else {
                result(nil)
              }
            })
            return
          }
        }

        UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error = error {
            result(FlutterError(code: "SET_ICON_FAILED", message: error.localizedDescription, details: nil))
          } else {
            result(nil)
          }
        }
      }

    case "resetToDefault":
      guard #available(iOS 10.3, *) else {
        result(nil)
        return
      }
      DispatchQueue.main.async {
        UIApplication.shared.setAlternateIconName(nil) { error in
          if let error = error {
            result(FlutterError(code: "RESET_FAILED", message: error.localizedDescription, details: nil))
          } else {
            result(nil)
          }
        }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

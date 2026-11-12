import Cocoa
import FlutterMacOS

public class DynamicColorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var accentObserver: NSObjectProtocol?
  private var accentSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "io.material.plugins/dynamic_color", binaryMessenger: registrar.messenger)
    let instance = DynamicColorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let accentChannel = FlutterEventChannel(
      name: "io.material.plugins/dynamic_color/accent_changes",
      binaryMessenger: registrar.messenger
    )
    accentChannel.setStreamHandler(instance)
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    accentSink = events
    accentObserver = NotificationCenter.default.addObserver(
      forName: NSColor.systemColorsDidChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.emitAccentColor()
    }
    emitAccentColor()
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if let accentObserver {
      NotificationCenter.default.removeObserver(accentObserver)
      self.accentObserver = nil
    }
    accentSink = nil
    return nil
  }

  private func emitAccentColor() {
    guard #available(macOS 10.14, *),
      let color = NSColor.controlAccentColor.usingColorSpace(.sRGB)
    else {
      return
    }
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let value = Int(alpha * 255) << 24 | Int(red * 255) << 16 |
      Int(green * 255) << 8 | Int(blue * 255)
    accentSink?(value)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAccentColor":
      if #available(macOS 10.14, *) {
        if let color = NSColor.controlAccentColor.usingColorSpace(.sRGB) {
          var r: CGFloat = 0
          var g: CGFloat = 0
          var b: CGFloat = 0
          var a: CGFloat = 0
          color.getRed(&r, green: &g, blue: &b, alpha: &a)
          let argb = (Int(a * 255) << 24) | (Int(r * 255) << 16) |
            (Int(g * 255) << 8) | Int(b * 255)
          result(argb)
        } else {
          result(nil)
        }
      } else {
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

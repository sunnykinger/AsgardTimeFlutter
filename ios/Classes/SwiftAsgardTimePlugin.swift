import Flutter
import UIKit

public class SwiftAsgardTimePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "asgard_time", binaryMessenger: registrar.messenger())
    let instance = SwiftAsgardTimePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    result("iOS " + UIDevice.current.systemVersion)
  }
}

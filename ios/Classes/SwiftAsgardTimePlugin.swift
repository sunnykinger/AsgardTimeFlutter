import Flutter
import UIKit

public class SwiftAsgardTimePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "asgard_time", binaryMessenger: registrar.messenger())
    let instance = SwiftAsgardTimePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    if (call.method == "getPlatformVersion") {
      result("iOS " + UIDevice.current.systemVersion);
    } 
    else if (call.method == "getTime") {
      let formatter = DateFormatter();
      formatter.timeZone = TimeZone.current;
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
      let str = formatter.string(from: Date());
      var dateString = str
      if str.hasSuffix("Z") {
            dateString = str.replacingOccurrences(of: "Z", with: "+00:00") 
        }
      result(dateString);
    } 
    else if (call.method == "getTimezone") {
      result(TimeZone.current.identifier);
    } 
    else if (call.method == "getOfflineTime") {
      if let interval = CheckinHelper.shared.getCurrentOfflineTime() {
        print("getCurrentOfflineTime interval: \(interval)")
            let date = Date(timeIntervalSince1970: interval)
            print("date: \(date)")
                let formatter = DateFormatter();
                formatter.timeZone = TimeZone.current;
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
                let str = formatter.string(from: date);
                var dateString = str
                print("dateString: \(dateString)")
                if str.hasSuffix("Z") {
                    dateString = str.replacingOccurrences(of: "Z", with: "+00:00") 
                }
            result(dateString)
      }
      else {
        result("")
      }
    }
    else {
      result(FlutterMethodNotImplemented);
    }
    
  }
}

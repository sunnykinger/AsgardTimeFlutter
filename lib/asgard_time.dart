
import 'dart:async';

import 'package:flutter/services.dart';

class AsgardTime {
  static const MethodChannel _channel =
      const MethodChannel('asgard_time');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get time async{
    final String time = await _channel.invokeMethod('getTime');
    return time;
  }
}

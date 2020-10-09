import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asgard_time/asgard_time.dart';

void main() {
  const MethodChannel channel = MethodChannel('asgard_time');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AsgardTime.platformVersion, '42');
  });
}

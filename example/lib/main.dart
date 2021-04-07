import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:asgard_time/asgard_time.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _currentTime = 'Unknown';
  String _timezone = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String currentTime;
    String timezone;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AsgardTime.platformVersion;
      currentTime = await AsgardTime.time;
      timezone = await AsgardTime.timezone;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _currentTime = currentTime;
      _timezone = timezone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Time is: $_currentTime\n'),
              Text('Timezone is:  $_timezone\n')
            ],
          ),
        ),
      ),
    );
  }
}

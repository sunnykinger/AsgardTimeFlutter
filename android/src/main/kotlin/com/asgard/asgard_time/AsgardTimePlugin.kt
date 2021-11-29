package com.asgard.asgard_time


import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.SimpleDateFormat
import java.util.*

/** AsgardTimePlugin */
class AsgardTimePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "asgard_time")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "getTime") {
            val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ")
            result.success(formatter.format(Date().time))
        } else if (call.method == "getTimezone") {
            val timezone = TimeZone.getDefault().id;
            result.success(timezone)
        } else if (call.method == "convertTime") {
            val args = call.arguments as Map<*, *>
            val time: Long = args["unixTime"] as Long
            val date = Date(time)
            val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ")
            result.success(formatter.format(date.time))
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

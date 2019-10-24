import 'dart:async';

import 'package:flutter/services.dart';

class SnapchatFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('snapchat_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map<dynamic, dynamic>> get snapchatLogin async {
    final Map<dynamic, dynamic> result =
        await _channel.invokeMethod('snap_chat_login');
    return (result.cast<String, dynamic>());
  }

  static Future<String> get snapchatLogout async {
    return await _channel.invokeMethod('snap_chat_logout');
  }
}

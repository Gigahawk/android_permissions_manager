import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AndroidPermissionsManager {
  static const MethodChannel _channel =
      const MethodChannel('android_permissions_manager');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<PermissionResult> requestPermission(PermissionType permission) async {
    final int status = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': describeEnum(permission)
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  static Future<PermissionResult> requestPermissionString(String permission) async {
    final int status = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': permission
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  static Future<PermissionResult> checkPermission(PermissionType permission) async {
    final int status = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': describeEnum(permission)
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  static Future<PermissionResult> checkPermissionString(String permission) async {
    final int status = await _channel.invokeMethod('checkPermission', <String, dynamic>{
      'permission': permission
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  static Future<bool> openSettings() async {
    final bool isOpen = await _channel.invokeMethod("openSettings");

    return isOpen;
  }
}

enum PermissionResult {
  granted,
  denied,
  showRationale,
}

enum PermissionType {
  READ_CALENDAR,
  WRITE_CALENDAR,
  CAMERA,
  READ_CONTACTS,
  WRITE_CONTACTS,
  GET_ACCOUNTS,
  ACCESS_FINE_LOCATION,
  ACCESS_COARSE_LOCATION,
  RECORD_AUDIO,
  READ_PHONE_STATE,
  READ_PHONE_NUMBERS,
  CALL_PHONE,
  ANSWER_PHONE_CALLS,
  READ_CALL_LOG,
  WRITE_CALL_LOG,
  ADD_VOICEMAIL,
  USE_SIP,
  PROCESS_OUTGOING_CALLS,
  BODY_SENSORS,
  SEND_SMS,
  RECEIVE_SMS,
  READ_SMS,
  RECEIVE_WAP_PUSH,
  RECEIVE_MMS,
  READ_EXTERNAL_STORAGE,
  WRITE_EXTERNAL_STORAGE,
}

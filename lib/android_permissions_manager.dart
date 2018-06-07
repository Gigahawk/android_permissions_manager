import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AndroidPermissionsManager {
  static const MethodChannel _channel =
      const MethodChannel('android_permissions_manager');


  /// Requests a permission from the user.
  ///
  /// If the permission has previously been granted or denied (i.e. user has
  /// requested that you stop requesting the permission) this function will
  /// immediately return [PermissionResult.denied] or [PermissionResult.showRationale].
  static Future<PermissionResult> requestPermission(PermissionType permission) async {
    final int status = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': describeEnum(permission)
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Requests a permission from the user.
  ///
  /// Permissions you can request can be found in [PermissionType].
  ///
  /// For example:
  /// ```dart
  /// PermisionResult result = requestPermissionString(describeEnum(PermissionType.READ_CALENDAR));
  /// ```
  ///
  /// For more information see [requestPermission()]
  static Future<PermissionResult> requestPermissionString(String permission) async {
    final int status = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': permission
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Checks if a permission has been previously granted.
  static Future<PermissionResult> checkPermission(PermissionType permission) async {
    final int status = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': describeEnum(permission)
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Checks if a permission has been previously granted.
  /// Permissions you can check can be found in [PermissionType].
  ///
  /// For example:
  /// ```dart
  /// PermisionResult result = checkPermissionString(describeEnum(PermissionType.READ_CALENDAR));
  /// ```
  static Future<PermissionResult> checkPermissionString(String permission) async {
    final int status = await _channel.invokeMethod('checkPermission', <String, dynamic>{
      'permission': permission
    });
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Opens the app settings for your app.
  ///
  /// Instantly returns true.
  static Future<bool> openSettings() async {
    final bool isOpen = await _channel.invokeMethod("openSettings");

    return isOpen;
  }
}

enum PermissionResult {
  /// Permission granted, you may use the requested resource.
  granted,
  /// Permission denied, you should stop requesting the resource.
  denied,
  /// Permission denied, you should tell the user why you need the resource.
  showRationale,
}

/// Supported permissions, for more info visit [here](https://developer.android.com/reference/android/Manifest.permission)
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

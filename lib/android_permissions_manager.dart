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
    final List<int> statuses = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': describeEnum(permission)
    });
    final int status = statuses[0];
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Requests a list of permissions from the user.
  ///
  /// For more information see [requestPermission()]
  static Future<List<PermissionResult>> requestPermissions(List<PermissionType> permissions) async {
    final List<int> statuses = await _channel.invokeMethod('requestPermissions', <String, dynamic>{
      'permissions': permissions.map((PermissionType type) => describeEnum(type)).toList(),
    });
    debugPrint(statuses.toString());

    return statuses.map((int status) => PermissionResult.values[status]).toList();
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
    final List<int> statuses = await _channel.invokeMethod('requestPermission', <String, dynamic>{
      'permission': permission
    });
    final int status = statuses[0];
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Requests a list of permissions from the user.
  ///
  /// For more information see [requestPermissionString()]
  static Future<List<PermissionResult>> requestPermissionsString(List<String> permissions) async {
    final List<int> statuses = await _channel.invokeMethod('requestPermissions', <String, dynamic>{
      'permissions': permissions,
    });
    debugPrint(statuses.toString());

    return statuses.map((int status) => PermissionResult.values[status]).toList();
  }

  /// Checks if a permission has been previously granted.
  static Future<PermissionResult> checkPermission(PermissionType permission) async {
    final List<int> statuses = await _channel.invokeMethod('checkPermission', <String, dynamic>{
      'permission': describeEnum(permission)
    });
    final int status = statuses[0];
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Checks if a list of permissions have been previously granted.
  ///
  /// For more information see [checkPermission()]
  static Future<List<PermissionResult>> checkPermissions(List<PermissionType> permissions) async {
    final List<int> statuses = await _channel.invokeMethod('checkPermissions', <String, dynamic>{
      'permissions': permissions.map((PermissionType type) => describeEnum(type)).toList(),
    });
    debugPrint(statuses.toString());

    return statuses.map((int status) => PermissionResult.values[status]).toList();
  }

  /// Checks if a permission has been previously granted.
  /// Permissions you can check can be found in [PermissionType].
  ///
  /// For example:
  /// ```dart
  /// PermisionResult result = checkPermissionString(describeEnum(PermissionType.READ_CALENDAR));
  /// ```
  static Future<PermissionResult> checkPermissionString(String permission) async {
    final List<int> statuses = await _channel.invokeMethod('checkPermission', <String, dynamic>{
      'permission': permission
    });
    final int status = statuses[0];
    debugPrint(status.toString());

    return PermissionResult.values[status];
  }

  /// Checks if a list of permissions have been previously granted.
  ///
  /// For more information see [checkPermissions()]
  static Future<List<PermissionResult>> checkPermissionsString(List<PermissionType> permissions) async {
    final List<int> statuses = await _channel.invokeMethod('checkPermissions', <String, dynamic>{
      'permissions': permissions,
    });
    debugPrint(statuses.toString());

    return statuses.map((int status) => PermissionResult.values[status]).toList();
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

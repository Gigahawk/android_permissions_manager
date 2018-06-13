import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_permissions_manager/android_permissions_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:android_permissions_manager_example/permissionsView.dart';

void main() => runApp(new MyApp());



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PermissionsButton> permissions = [
    PermissionsButton("READ_CALENDAR"),
    PermissionsButton("WRITE_CALENDAR"),
    PermissionsButton("CAMERA"),
    PermissionsButton("READ_CONTACTS"),
    PermissionsButton("WRITE_CONTACTS"),
    PermissionsButton("GET_ACCOUNTS"),
    PermissionsButton("ACCESS_FINE_LOCATION"),
    PermissionsButton("ACCESS_COARSE_LOCATION"),
    PermissionsButton("RECORD_AUDIO"),
    PermissionsButton("READ_PHONE_STATE"),
    PermissionsButton("READ_PHONE_NUMBERS"),
    PermissionsButton("CALL_PHONE"),
    PermissionsButton("ANSWER_PHONE_CALLS"),
    PermissionsButton("READ_CALL_LOG"),
    PermissionsButton("WRITE_CALL_LOG"),
    PermissionsButton("ADD_VOICEMAIL"),
    PermissionsButton("USE_SIP"),
    PermissionsButton("PROCESS_OUTGOING_CALLS"),
    PermissionsButton("BODY_SENSORS"),
    PermissionsButton("SEND_SMS"),
    PermissionsButton("RECEIVE_SMS"),
    PermissionsButton("READ_SMS"),
    PermissionsButton("RECEIVE_WAP_PUSH"),
    PermissionsButton("RECEIVE_MMS"),
    PermissionsButton("READ_EXTERNAL_STORAGE"),
    PermissionsButton("WRITE_EXTERNAL_STORAGE"),
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                bool result = await AndroidPermissionsManager.openSettings();
                debugPrint(result.toString());
              }
            ),
            IconButton(
              icon: Icon(Icons.sms),
              onPressed: () async {
                List<PermissionResult> results = await AndroidPermissionsManager.requestPermissions(<PermissionType>[
                  PermissionType.SEND_SMS,
                  PermissionType.READ_SMS,
                ]);
                debugPrint(results.toString());
              },
            )
          ],
        ),
        body: Center(
          child: PermissionsGridView(permissions),
        )
      ),
    );
  }
}

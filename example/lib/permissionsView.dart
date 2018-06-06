import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_permissions_manager/android_permissions_manager.dart';
import 'package:flutter/foundation.dart';

class PermissionsButton extends StatefulWidget {
  final String permission;
  String rationale;

  PermissionsButton(this.permission) {
    this.rationale = "Permission $permission is required for this application";
  }

  @override
  _PermissionsButtonState createState() => new _PermissionsButtonState();
}

class _PermissionsButtonState extends State<PermissionsButton> with AutomaticKeepAliveClientMixin<PermissionsButton>{
  bool _granted = false;
  bool _denied = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _checkPermission();
    super.initState();
  }

  void _checkPermission() async {
    debugPrint("Checking ${widget.permission}");
    PermissionResult result = await AndroidPermissionsManager.checkPermissionString(widget.permission);
    debugPrint("${widget.permission}: ${describeEnum(result)}");

    switch(result) {
      case PermissionResult.granted:
        setState(() {
          _granted = true;
        });
        break;
      case PermissionResult.denied:
        setState(() {
          _granted = false;
        });
        break;
      case PermissionResult.showRationale:
        setState(() {
          _granted = false;
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Card(
        elevation: 1.0,
        color: _denied ? Colors.red[100] : _granted ? Colors.green[100] : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.permission),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Request"),
                  onPressed: _granted || _denied ? null : () async {
                    PermissionResult result = await AndroidPermissionsManager.requestPermissionString(widget.permission);
                    debugPrint("${widget.permission}: ${describeEnum(result)}");
                    switch(result) {
                      case PermissionResult.granted:
                        setState(() {
                          _granted = true;
                        });
                        break;
                      case PermissionResult.denied:
                        setState(() {
                          _granted = false;
                          _denied = true;
                        });
                        break;
                      case PermissionResult.showRationale:
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(widget.rationale),
                          duration: const Duration(seconds: 3),
                        ));
                        break;
                      default:
                        break;
                    }
                  },
                ),
              )
            ],
          ),
        ),
    );
  }

}

class PermissionsGridView extends StatefulWidget {
  List<PermissionsButton> permissionButtons;

  PermissionsGridView(this.permissionButtons);
  @override
  _PermissionsGridViewState createState() => new _PermissionsGridViewState();
}

class _PermissionsGridViewState extends State<PermissionsGridView> {

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      padding: EdgeInsets.all(1.0),
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: widget.permissionButtons
    );
//    return CustomScrollView(
//      slivers: <Widget>[
//        SliverGrid.count(
//          mainAxisSpacing: 1.0,
//          crossAxisSpacing: 1.0,
//          crossAxisCount: 2,
//          childAspectRatio: 1.0,
//          children: widget.permissionButtons,
//        )
//      ],
//    );
  }
}
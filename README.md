# android_permissions_manager

Plugin to manage permissions on Android.

Based heavily on [flutter_simple_permissions](https://github.com/Ethras/flutter_simple_permissions).


## Getting Started
Add the dependency to your `pubspec.yaml`:
```yaml
dependencies:
  android_permissoins_manager: any
```

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Usage Example
Import the package:
```dart
import 'package:android_permissions_manager/android_permissions_manager.dart'
```

### Requesting a Permission
`requestPermission()` will open a dialog for the user to allow or deny the permission you are asking for.
```dart
PermissionResult result = await AndroidPermissionsManager.requestPermission(PermissionType.CAMERA);

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
    // showRationale means you should show the user why you need this permission
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("We need the camera to show an image preview"),
    ));
    setState(() {
      _granted = false;
    });
    break;
}
```

### Checking a Permission
`checkPermission()` will check if a user has previously granted a permission.
```dart
PermissionResult result = await AndroidPermissionsManager.checkPermission(PermissionType.CAMERA);

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
    // showRationale should be treated as denied when checking permissions
    setState(() {
      _granted = false;
    });
    break;
}
```

### Opening Settings
Sometimes you will have top open the app settings (i.e. if a user has accidentally permanently denied a permision that you need)
```dart
// Always returns true instantly
bool result = await AndroidPermissionsManager.openSettings();
```

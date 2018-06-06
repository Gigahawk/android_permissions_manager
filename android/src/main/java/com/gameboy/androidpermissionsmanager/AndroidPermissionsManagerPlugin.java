package com.gameboy.androidpermissionsmanager;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;


/**
 * AndroidPermissionsManagerPlugin
 */
public class AndroidPermissionsManagerPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener{

  private PermissionCallback permissionCallback;

  private final Registrar registrar;
  private Result result;

  private static final int GET_PERMISSION_REQUEST_ID = 9001;

  private boolean rationaleJustShown = false;
  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "android_permissions_manager");
    AndroidPermissionsManagerPlugin androidPermissionsManagerPlugin = new AndroidPermissionsManagerPlugin(registrar);
    channel.setMethodCallHandler(androidPermissionsManagerPlugin);
    registrar.addRequestPermissionsResultListener(androidPermissionsManagerPlugin);
  }

  private AndroidPermissionsManagerPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    permissionCallback = new PermissionCallback() {
      @Override
      public void granted() {
        rationaleJustShown = false;
        result.success(0);
      }

      @Override
      public void denied() {
        rationaleJustShown = false;
        result.success(1);
      }

      @Override
      public void showRationale() {
        rationaleJustShown = true;
        result.success(2);
      }
    };
    String permission;
    switch (call.method){
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "checkPermission":
        permission = call.argument("permission");
        checkPermission(permission);
        break;
      case "requestPermission":
        permission = call.argument("permission");
        this.result = result;
        requestPermission(permission);
        break;
      case "openSettings":
        openSettings();
        result.success(true);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void openSettings() {
    Activity activity = registrar.activity();
    Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:" + activity.getPackageName()));
    intent.addCategory(Intent.CATEGORY_DEFAULT);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    activity.startActivity(intent);
  }
  private void requestPermission(String permission) {
      Activity activity = registrar.activity();
      permission = stringToPermission(permission);
      Log.i("AndroidPermissionsMgr", "Requesting permission: " + permission);
      String[] perm = {permission};
      ActivityCompat.requestPermissions(activity, perm, GET_PERMISSION_REQUEST_ID);
  }

  private void checkPermission(String permission) {
    Activity activity = registrar.activity();
    permission = stringToPermission(permission);
    Log.i("AndroidPermissionsMgr", "Checking permission: " + permission);
    boolean res = PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(activity, permission);
    if(res) {
      permissionCallback.granted();
    } else if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)) {
      permissionCallback.showRationale();
    } else {
      permissionCallback.denied();
    }
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    Activity activity = registrar.activity();
    switch (requestCode) {
      case GET_PERMISSION_REQUEST_ID:
        // If request is cancelled, the result arrays are empty.
        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
          permissionCallback.granted();
          return true;
        } else if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permissions[0])) {
          permissionCallback.showRationale();
          return false;
        } else {
          permissionCallback.denied();
          return false;
        }
    }
    return false;
  }

  public interface PermissionCallback {
    void granted();

    void denied();

    void showRationale();
  }

  private String stringToPermission(String perm) {
    switch (perm) {
      case "READ_CALENDAR": return Manifest.permission.READ_CALENDAR;
      case "WRITE_CALENDAR": return Manifest.permission.WRITE_CALENDAR;
      case "CAMERA": return Manifest.permission.CAMERA;
      case "READ_CONTACTS": return Manifest.permission.READ_CONTACTS;
      case "WRITE_CONTACTS": return Manifest.permission.WRITE_CONTACTS;
      case "GET_ACCOUNTS": return Manifest.permission.GET_ACCOUNTS;
      case "ACCESS_FINE_LOCATION": return Manifest.permission.ACCESS_FINE_LOCATION;
      case "ACCESS_COARSE_LOCATION": return Manifest.permission.ACCESS_COARSE_LOCATION;
      case "RECORD_AUDIO": return Manifest.permission.RECORD_AUDIO;
      case "READ_PHONE_STATE": return Manifest.permission.READ_PHONE_STATE;
      case "READ_PHONE_NUMBERS": return Manifest.permission.READ_PHONE_NUMBERS;
      case "CALL_PHONE": return Manifest.permission.CALL_PHONE;
      case "ANSWER_PHONE_CALLS": return Manifest.permission.ANSWER_PHONE_CALLS;
      case "READ_CALL_LOG": return Manifest.permission.READ_CALL_LOG;
      case "WRITE_CALL_LOG": return Manifest.permission.WRITE_CALL_LOG;
      case "ADD_VOICEMAIL": return Manifest.permission.ADD_VOICEMAIL;
      case "USE_SIP": return Manifest.permission.USE_SIP;
      case "PROCESS_OUTGOING_CALLS": return Manifest.permission.PROCESS_OUTGOING_CALLS;
      case "BODY_SENSORS": return Manifest.permission.BODY_SENSORS;
      case "SEND_SMS": return Manifest.permission.SEND_SMS;
      case "RECEIVE_SMS": return Manifest.permission.RECEIVE_SMS;
      case "READ_SMS": return Manifest.permission.READ_SMS;
      case "RECEIVE_WAP_PUSH": return Manifest.permission.RECEIVE_WAP_PUSH;
      case "RECEIVE_MMS": return Manifest.permission.RECEIVE_MMS;
      case "READ_EXTERNAL_STORAGE": return Manifest.permission.READ_EXTERNAL_STORAGE;
      case "WRITE_EXTERNAL_STORAGE": return Manifest.permission.WRITE_EXTERNAL_STORAGE;
    }
    return null;
  }
}

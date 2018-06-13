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

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

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
  private static final int PERMISSION_GRANTED = 0;
  private static final int PERMISSION_DENIED = 1;
  private static final int PERMISSION_SHOW_RATIONALE = 2;

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
      public void result(int[] results) {
        result.success(results);

      }
    };
    String permission;
    ArrayList<String> permissions;
    switch (call.method){
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "checkPermission":
        permission = call.argument("permission");
        permissions = new ArrayList<String>();
        permissions.add(permission);
        checkPermissions(permissions);
        break;
      case "checkPermissions":
        permissions = new ArrayList<String>();
        permissions = call.argument("permissions");
        this.result = result;
        checkPermissions(permissions);
      case "requestPermission":
        permission = call.argument("permission");
        permissions = new ArrayList<String>();
        permissions.add(permission);
        this.result = result;
        requestPermissions(permissions);
        break;
      case "requestPermissions":
        permissions = new ArrayList<String>();
        permissions = call.argument("permissions");
        this.result = result;
        requestPermissions(permissions);
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
  private void requestPermissions(ArrayList<String> permissions) {
      Activity activity = registrar.activity();
      List<String> perms = new ArrayList<String>();
      perms = permissions.stream().map(perm -> stringToPermission(perm)).collect(Collectors.toList());

      Log.i("AndroidPermissionsMgr", "Requesting permissions: " + perms.toString());
      String[] permsToRequest = new String[perms.size()];
      permsToRequest = perms.toArray(permsToRequest);
      ActivityCompat.requestPermissions(activity, permsToRequest, GET_PERMISSION_REQUEST_ID);
  }

  private int checkPermission(Activity activity, String perm){
    boolean res = PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(activity, perm);
    if(res)
      return PERMISSION_GRANTED;
    else
      return PERMISSION_DENIED;
  }


  private void checkPermissions(ArrayList<String> permissions) {
    Activity activity = registrar.activity();
    List<String> perms = new ArrayList<String>();
    perms = permissions.stream().map(perm -> stringToPermission(perm)).collect(Collectors.toList());
    Log.i("AndroidPermissionsMgr", "Checking permissions: " + perms.toString());
    List<Integer> results = new ArrayList<Integer>();
    results = perms.stream().map(perm -> checkPermission(activity, perm)).collect(Collectors.toList());
    int[] res = new int[results.size()];
    res = results.stream().mapToInt(i -> i).toArray();
    permissionCallback.result(res);
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    Activity activity = registrar.activity();
    switch (requestCode) {
      case GET_PERMISSION_REQUEST_ID:
        // If request is cancelled, the result arrays are empty.
        if (grantResults.length > 0) {
            permissionCallback.result(grantResults);
            return true;
        } else {
          return false;
        }
    }
    return false;
  }


  public interface PermissionCallback {
      void result(int[] results);
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

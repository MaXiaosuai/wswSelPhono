package ma.xiaoshuai.cordova.wswSelPhono;

import android.annotation.SuppressLint;
import android.app.Application;
import android.util.Log;

import com.hjq.permissions.OnPermissionCallback;
import com.hjq.permissions.Permission;
import com.hjq.permissions.XXPermissions;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.cache.CacheEntity;
import com.lzy.okgo.cache.CacheMode;
import com.lzy.okgo.cookie.CookieJarImpl;
import com.lzy.okgo.cookie.store.DBCookieStore;
import com.lzy.okgo.interceptor.HttpLoggingInterceptor;

import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;

import okhttp3.OkHttpClient;

/**
 * This class echoes a string called from JavaScript.
 */

public class wswSelPhono extends CordovaPlugin {
  protected static CallbackContext currentCallbackContext;
  public static final String TAG = "Cordova.Plugin.wswSelPhono";
  public static final String ERROR_INVALID_PARAMETERS = "选照片失败";


  @Override
  public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("selPhoto")) {
      return selPhoto(args, callbackContext);
    }else if (action.equals("selCamera")) {
      return selCamera(args, callbackContext);
    }

    return false;
  }

  @SuppressLint({"selPhoto", "LongLogTag"})
  protected boolean selPhoto(CordovaArgs args, CallbackContext callbackContext) {
    JSONObject params = null;
    currentCallbackContext = callbackContext;
    try {
      params = args.getJSONObject(0);
      String max = params.getString("max");

      if (XXPermissions.isGranted(cordova.getContext(),Permission.CAMERA)){
        SelPhonoUtil.selectPic(cordova.getActivity(),currentCallbackContext,max);
      }else {
        XXPermissions.with(cordova.getContext())
          // 不适配 Android 11 可以这样写
          //.permission(Permission.Group.STORAGE)
          // 适配 Android 11 需要这样写，这里无需再写 Permission.Group.STORAGE
          .permission(Permission.CAMERA)
          .request(new OnPermissionCallback() {
            @Override
            public void onGranted(List<String> permissions, boolean all) {
              if (all) {
                SelPhonoUtil.selectPic(cordova.getActivity(),  currentCallbackContext,max);
              }
            }

            @Override
            public void onDenied(List<String> permissions, boolean never) {
              if (never) {
                currentCallbackContext.error("被永久拒绝授权，请手动授予存储权限");
              } else {
                currentCallbackContext.error("获取存储权限失败");
              }
            }
          });
      }
      return true;

    } catch (JSONException e) {
      e.printStackTrace();
      callbackContext.error(ERROR_INVALID_PARAMETERS);
      return false;
    }
  }


  @SuppressLint({"selCamera", "LongLogTag"})
  protected boolean selCamera(CordovaArgs args, CallbackContext callbackContext) {
    JSONObject params = null;
    currentCallbackContext = callbackContext;

      if (XXPermissions.isGranted(cordova.getContext(),Permission.CAMERA)){
        SelPhonoUtil.selCamera(cordova.getActivity(),currentCallbackContext);
      }else {
        XXPermissions.with(cordova.getContext())
          // 不适配 Android 11 可以这样写
          //.permission(Permission.Group.STORAGE)
          // 适配 Android 11 需要这样写，这里无需再写 Permission.Group.STORAGE
          .permission(Permission.CAMERA)
          .request(new OnPermissionCallback() {
            @Override
            public void onGranted(List<String> permissions, boolean all) {
              if (all) {
                SelPhonoUtil.selCamera(cordova.getActivity(),  currentCallbackContext);
              }
            }

            @Override
            public void onDenied(List<String> permissions, boolean never) {
              if (never) {
                currentCallbackContext.error("被永久拒绝授权，请手动授予存储权限");
              } else {
                currentCallbackContext.error("获取存储权限失败");
              }
            }
          });
      }
      return true;

  }
}

package ma.xiaoshuai.cordova.wswSelPhono;

import static com.yalantis.ucrop.view.OverlayView.FREESTYLE_CROP_MODE_ENABLE;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.util.Base64;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import com.bumptech.glide.Glide;
import com.luck.picture.lib.PictureSelector;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.entity.LocalMedia;
import com.luck.picture.lib.listener.OnResultCallbackListener;
import com.lzy.okgo.BuildConfig;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.FileCallback;
import com.lzy.okgo.model.Progress;
import com.lzy.okgo.model.Response;
import com.lzy.okgo.request.base.Request;

import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import io.ionic.starter.R;

public class SelPhonoUtil {
  private static ProgressBar pb;
  private static TextView tvStrPro;
  private static ProgressDialog progressDialog;
  private static Context mContext;
  private static String path;
  //  private static List<String> list = new ArrayList<String>();
  private static JSONArray jsonArray = new JSONArray();

  protected static CallbackContext currentCallbackContext;

  public static void selectPic(Context context, CallbackContext callbackContext,String max) {
    int i = Integer.parseInt(max);
    currentCallbackContext = callbackContext;
    PictureSelector.create((Activity) context)
      .openGallery(PictureMimeType.ofAll())
      .imageEngine(GlideEngine.createGlideEngine())
      .isEnableCrop(true)
      .maxSelectNum(i)
      .freeStyleCropMode(FREESTYLE_CROP_MODE_ENABLE)
      .showCropFrame(true)
      .showCropGrid(true)
      .forResult(new OnResultCallbackListener<LocalMedia>() {
        @Override
        public void onResult(List<LocalMedia> result) {
          for (LocalMedia item : result) {
            path = item.getCutPath();
            path = imageToBase64(path);
            jsonArray.put(path);
          }

          currentCallbackContext.success(jsonArray);

          // 结果回调
          Log.e("select", path);
        }

        @Override
        public void onCancel() {
          // 取消
          currentCallbackContext.error("取消选择");
        }
      });
  }

  public static  void selCamera(Context context, CallbackContext callbackContext) {
    currentCallbackContext = callbackContext;
    PictureSelector.create((Activity) context)
      .openCamera(PictureMimeType.ofImage())
      .imageEngine(GlideEngine.createGlideEngine())
      .isEnableCrop(true)
      .maxSelectNum(1)
      .freeStyleCropMode(FREESTYLE_CROP_MODE_ENABLE)
      .showCropFrame(true)
      .showCropGrid(true)
      .forResult(new OnResultCallbackListener<LocalMedia>() {
        @Override
        public void onResult(List<LocalMedia> result) {

          path = result.get(0).getCutPath();
          path = imageToBase64(path);
          currentCallbackContext.success(path);

          // 结果回调
          Log.e("select", path);
        }

        @Override
        public void onCancel() {
          // 取消
          currentCallbackContext.error("取消拍照");
        }
      });
  }

  /**
   * 将图片转换成Base64编码的字符串
   */
  /**
   * 将图片转换成Base64编码的字符串
   */
  public static String imageToBase64(String path) {

    InputStream is = null;
    byte[] data = null;
    String result = null;
    try {
      is = new FileInputStream(path);
      //创建一个字符流大小的数组。
      data = new byte[is.available()];
      //写入数组
      is.read(data);
      //用默认的编码格式进行编码
      result = Base64.encodeToString(data, Base64.NO_WRAP);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (null != is) {
        try {
          is.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }

    }
    return result;
  }

}


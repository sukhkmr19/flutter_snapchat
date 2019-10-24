package com.proflutterdev.snapchat_flutter_plugin;

import android.app.Activity;
import android.text.TextUtils;

import com.snapchat.kit.sdk.SnapLogin;
import com.snapchat.kit.sdk.core.controller.LoginStateController;
import com.snapchat.kit.sdk.login.models.MeData;
import com.snapchat.kit.sdk.login.models.UserDataResponse;
import com.snapchat.kit.sdk.login.networking.FetchUserDataCallback;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SnapchatFlutterPlugin
 */
public class SnapchatFlutterPlugin implements MethodCallHandler,
        LoginStateController.OnLoginStateChangedListener {
    private Activity _activity;
    private MethodChannel.Result _result;

    public SnapchatFlutterPlugin(Activity activity) {
        this._activity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "snapchat_flutter_plugin");
        channel.setMethodCallHandler(new SnapchatFlutterPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("snap_chat_login")) {
            SnapLogin.getLoginStateController(_activity).addOnLoginStateChangedListener(this);
            SnapLogin.getAuthTokenManager(_activity).startTokenGrant();
            this._result = result;
        } else if (call.method.equals("snap_chat_logout")) {
            SnapLogin.getLoginStateController(_activity).removeOnLoginStateChangedListener(this);
            SnapLogin.getAuthTokenManager(_activity).revokeToken();
            this._result = result;
        } else {
            result.notImplemented();
        }
    }

    public void fetchUserData() {
        String query = "{me{bitmoji{avatar},displayName,externalId}}";
        SnapLogin.fetchUserData(_activity, query, null, new FetchUserDataCallback() {
            @Override
            public void onSuccess(UserDataResponse userDataResponse) {
                if (userDataResponse == null || userDataResponse.getData() == null) {
                    return;
                }

                MeData meData = userDataResponse.getData().getMe();
                if (meData == null) {
                    _result.error("400", "Error in login", null);
                    return;
                }
                Map<String, Object> data = new HashMap<String, Object>();
                data.put("fullName", meData.getDisplayName());
                data.put("_id", meData.getExternalId());
                if (meData.getBitmojiData() != null) {
                    if (!TextUtils.isEmpty(meData.getBitmojiData().getAvatar())) {
                        data.put("avatar", meData.getBitmojiData().getAvatar());
                    }
                }
                _result.success(data);

            }

            @Override
            public void onFailure(boolean isNetworkError, int statusCode) {
                _result.error("400", "Error in login", null);
            }
        });
    }

    @Override
    public void onLoginSucceeded() {
        fetchUserData();
    }

    @Override
    public void onLoginFailed() {
    }

    @Override
    public void onLogout() {
        _result.success("logout");
    }

}

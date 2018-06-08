
package com.gratong;

import com.facebook.react.bridge.ActivityEventListener;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.auth.WbAuthListener;
import com.sina.weibo.sdk.auth.WbConnectErrorMessage;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.sso.SsoHandler;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.auth.WbAuthListener;

public class WeiBoModule extends ReactContextBaseJavaModule{

    private final ReactApplicationContext mContext;
    private static final String RCTWBEventName = "weibo_login";

    /** 注意：SsoHandler 仅当 SDK 支持 SSO 时有效 */
    private SsoHandler mSsoHandler;

    public WeiBoModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            if (mSsoHandler != null) {
                mSsoHandler.authorizeCallBack(requestCode, resultCode, data);
            }
        }
    };

    @ReactMethod
    public void login(final ReadableMap config, final Callback callback){
        if (mSsoHandler == null){
            String appKey = config.getString("appKey");
            String redirectURI = config.getString("redirectURI");
            String scope = config.getString("scope");

            AuthInfo mAuthInfo = new AuthInfo(mContext, appKey, redirectURI, scope);
            WbSdk.install(mContext,mAuthInfo);

            mSsoHandler = new SsoHandler(mContext.getCurrentActivity());
        }

        mSsoHandler.authorize(new SelfWbAuthListener());
        callback.invoke("Weibo open success.");
    }

    private class SelfWbAuthListener implements WbAuthListener{
        @Override
        public void onSuccess(final Oauth2AccessToken token) {
            Log.d("'WbAuthListener:","onSuccess");
            WritableMap map = new WritableNativeMap();
            if (token.isSessionValid()) {
                map.putString("accessToken", token.getToken());
                map.putDouble("expirationDate", token.getExpiresTime());
                map.putString("userID", token.getUid());
                map.putString("refreshToken", token.getRefreshToken());
                map.putInt("errCode", 0);
            } else {
                map.putInt("errCode", -1);
                map.putString("errMsg", "token invalid");
            }
            map.putString("type", "WBAuthorizeResponse");
            mContext.getJSModule(RCTNativeAppEventEmitter.class).emit(RCTWBEventName,map);
        }

        @Override
        public void cancel() {
            Log.d("'WbAuthListener:","cancel");
            WritableMap map = new WritableNativeMap();
            map.putString("type", "WBAuthorizeResponse");
            map.putString("errMsg", "Cancel");
            map.putInt("errCode", -1);
            mContext.getJSModule(RCTNativeAppEventEmitter.class).emit(RCTWBEventName,map);
        }

        @Override
        public void onFailure(WbConnectErrorMessage errorMessage) {
            Log.d("WbAuthListener","onFailure: "+errorMessage.getErrorMessage());
            WritableMap map = new WritableNativeMap();
            map.putString("type", "WBAuthorizeResponse");
            map.putString("errMsg", errorMessage.getErrorMessage());
            map.putInt("errCode", -1);
            mContext.getJSModule(RCTNativeAppEventEmitter.class).emit(RCTWBEventName,map);
        }
    }

    @Override
    public String getName() {
        return "WeiBo";
    }

}
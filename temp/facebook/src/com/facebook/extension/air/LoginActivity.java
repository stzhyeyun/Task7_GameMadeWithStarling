package com.facebook.extension.air;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import java.util.ArrayList;

import org.json.JSONObject;

/**
 * Created by user on 2016-06-02.
 */
public class LoginActivity extends Activity {

	public static FREContext freContext;
	
	private static CallbackManager _callbackManager;

	private final String TAG = "[LoginActivity]";
	
    private final String ACCESS_TOKEN = "accessToken";
    private final String USER_INFO = "userInfo";

    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize
        FacebookSdk.sdkInitialize(getApplicationContext());
        
//        if (BuildConfig.DEBUG)
//        {
//            FacebookSdk.setIsDebugEnabled(true);
//            FacebookSdk.addLoggingBehavior(LoggingBehavior.INCLUDE_ACCESS_TOKENS);
//        }
        
        // Create CallbackManager
        _callbackManager = CallbackManager.Factory.create();

        // Register callback to LoginManager
        LoginManager.getInstance().registerCallback(
        		_callbackManager,
                new FacebookCallback<LoginResult>() {
        	
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        
                    	Log.d(TAG, " Login succeeded.");
                        
                    	AccessToken accessToken = loginResult.getAccessToken();
                    	
                        GraphRequest request = GraphRequest.newMeRequest(
                        		accessToken,
                                new GraphRequest.GraphJSONObjectCallback() {
                        			
                                    @Override
                                    public void onCompleted(
                                    		JSONObject object,
                                    		GraphResponse response) {
                                    	
                                        Log.v(TAG, " " + response.toString());
                                        
                                        // dispatch event with userinfo                                    
                                        freContext.dispatchStatusEventAsync(USER_INFO, response.toString());
                                        finish();
                                    }
                                    
                                });
                        
                        Bundle parameters = new Bundle();
                        parameters.putString("fields", "id, name");
                        request.setParameters(parameters);
                        request.executeAsync();
                        
                        // dispatch event with accessToken
                        freContext.dispatchStatusEventAsync(
                        		ACCESS_TOKEN, AccessTokenStringfier.stringfy(accessToken));
                    }

                    @Override
                    public void onCancel() {
                    	
                        Log.d(TAG, " Login cancelled.");
                        finish();
                    }

                    @Override
                    public void onError(FacebookException exception) {

                    	Log.d(TAG, " Login error occurred.");
                        Log.d(TAG, " " + exception.toString());
                        finish();
                    }
                });

        // Login
        ArrayList<String> permissions = this.getIntent().getStringArrayListExtra("permissions");
        
        if (permissions != null)
        {
        	LoginManager.getInstance().logInWithReadPermissions(this, permissions);
        }
        else
        {
        	Log.d (TAG, " onCreate : permissions is null.");
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        _callbackManager.onActivityResult(requestCode, resultCode, data);
    }

}

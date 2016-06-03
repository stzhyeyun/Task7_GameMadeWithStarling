package com.facebook.extension.air;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.facebook.login.LoginManager;

import android.content.Intent;

/**
 * Created by user on 2016-06-01.
 */
public class Logout implements FREFunction {

    public FREObject call(FREContext freContext, FREObject[] objects)
    {
    	LogoutActivity.freContext = freContext;

        Intent intent = new Intent(freContext.getActivity().getApplicationContext(), LogoutActivity.class);
        freContext.getActivity().startActivity(intent);   
        
        return null;
    }
}

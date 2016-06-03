package com.facebook.extension.air;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

/**
 * Created by user on 2016-06-01.
 */
public class FacebookContext extends FREContext {

    @Override
    public void dispose()
    {

    }

    @Override
    public Map<String, FREFunction> getFunctions()
    {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

        functions.put("logInWithReadPermissions", new LogInWithReadPermissions());
        //functions.put("logInWithReadPermissions", new LogInWithReadPermissions());
        functions.put("logOut", new Logout());

        return functions;
    }

}

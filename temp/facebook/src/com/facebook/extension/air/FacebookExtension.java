package com.facebook.extension.air;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * Created by user on 2016-06-01.
 */
public class FacebookExtension implements FREExtension {

    @Override
    public FREContext createContext(String arg0)
    {
        return new FacebookContext();
    }

    @Override
    public void dispose()
    {

    }

    @Override
    public void initialize()
    {

    }

}

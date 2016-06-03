package com.facebook.extension.air;

import android.content.Intent;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

import java.util.ArrayList;

/**
 * Created by user on 2016-06-01.
 */
public class LogInWithReadPermissions implements FREFunction {

    public FREObject call(FREContext freContext, FREObject[] objects)
    {
    	LoginActivity.freContext = freContext;
    	
        FREArray freArray = (FREArray)objects[0];
        long length = 0;
        try
        {
            length = freArray.getLength();
        }
        catch (FREInvalidObjectException e1)
        {
            e1.printStackTrace();
        }
        catch (FREWrongThreadException e1)
        {
            e1.printStackTrace();
        }

        ArrayList<String> permissions = new ArrayList<String>();
        for (int i = 0; i < (int)length; i++)
        {
            try
            {
                permissions.add(freArray.getObjectAt(i).getAsString());
            }
            catch (IllegalStateException e)
            {
                e.printStackTrace();
            }
            catch (FRETypeMismatchException e)
            {
                e.printStackTrace();
            }
            catch (FREInvalidObjectException e)
            {
                e.printStackTrace();
            }
            catch (FREWrongThreadException e)
            {
                e.printStackTrace();
            }
        }
        
        Intent intent = new Intent(freContext.getActivity().getApplicationContext(), LoginActivity.class);
        intent.putStringArrayListExtra("permissions", permissions);
        freContext.getActivity().startActivity(intent);   

        return null;
    }

}

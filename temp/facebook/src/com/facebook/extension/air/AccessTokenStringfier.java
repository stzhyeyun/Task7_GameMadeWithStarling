package com.facebook.extension.air;

import java.util.Set;

import com.facebook.AccessToken;

public class AccessTokenStringfier {

	public static String stringfy(AccessToken accessToken)
	{
		String strToken = 
				"{ userId : " + accessToken.getUserId() + " } " +
				"{ accessToken : " + accessToken.getToken() + " } " +
				"{ expires : " + accessToken.getExpires().toString() + " } { permissions : ";
		
		int i = 0;
		Set<String> permissions = accessToken.getPermissions();
		for (String element : permissions)
		{
			if (i != 0)
			{
				strToken += ", ";
			}
			
			strToken += element;
			i++;
		}
		strToken += " }";
		
		return strToken;
	}
	
}

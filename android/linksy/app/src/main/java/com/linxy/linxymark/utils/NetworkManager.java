package com.linxy.linxymark.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;


// needs android.permission.ACCESS_NETWORK_STATE
public class NetworkManager {
    public static boolean isOnline(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        return (networkInfo != null && networkInfo.isAvailable() && networkInfo.isConnected());
    }
}

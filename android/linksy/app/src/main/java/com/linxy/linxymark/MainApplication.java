package com.linxy.linxymark;

import android.app.Application;
import android.content.res.Configuration;

public class MainApplication extends Application {

//	public static final List<Locale> SUPPORTED_LOCALES =
//			Arrays.asList(
//					new Locale("en", "US"),
//					new Locale("es", "ES")
//			);

	@Override
	public void onCreate() {
		super.onCreate();
		//LocaleChanger.initialize(getApplicationContext(), SUPPORTED_LOCALES);
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
	//	LocaleChanger.onConfigurationChanged();
	}



}
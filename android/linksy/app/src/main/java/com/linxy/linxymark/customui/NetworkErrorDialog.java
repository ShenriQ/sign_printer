//
//  NetworkErrorDialog.java
//  com.hp.linkreadersdk
//  LinkReaderSDK
//
//  Copyright (c) 2015 HP. All rights reserved.

package com.linxy.linxymark.customui;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ScrollView;
import android.widget.TextView;

import com.linxy.linxymark.R;


public class NetworkErrorDialog extends Dialog {

	public static final String TAG = "NetworkErrorDialog";

	public NetworkErrorDialog(Activity activity) {
		super(activity);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.custom_alert_dialog);
		View widthView = findViewById(R.id.width_view);
		TextView alertTitle = (TextView) findViewById(R.id.custom_alert_title_text);
		alertTitle.setText(R.string.network_error_title);
		ScrollView alertMessageScroll = (ScrollView) findViewById(R.id.custom_alert_scroll);
		TextView alertMessage = (TextView) findViewById(R.id.custom_alert_message_text);
		alertMessage.setText(R.string.network_error_body);
		TextView okView = (TextView) findViewById(R.id.custom_alert_ok_text);
		okView.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				cancel();
			}
		});
		TextView retryView = (TextView) findViewById(R.id.custom_alert_retry_text);
		retryView.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				dismiss();
			}
		});
	}
}

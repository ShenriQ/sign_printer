package com.linxy.linxymark.customui;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ScrollView;
import android.widget.TextView;

import com.linxy.linxymark.R;

// This class is an example to show how a payoff could be showed to the user
public class PayoffContentDialog extends Dialog {

    public static final String TAG = "AuthenticationErrorDialog";

	public PayoffContentDialog(Activity activity, Bundle bundle) {
		super(activity);
		payoff = bundle;
	}

	private Bundle payoff;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);

		setContentView(R.layout.custom_alert_dialog);
		View widthView = findViewById(R.id.width_view);
		TextView alertTitle = (TextView) findViewById(R.id.custom_alert_title_text);
		alertTitle.setText(payoff.getString("payoff_type"));
		ScrollView alertMessageScroll = (ScrollView) findViewById(R.id.custom_alert_scroll);
		TextView alertMessage = (TextView) findViewById(R.id.custom_alert_message_text);
		alertMessage.setText(payoff.getString("payoff_content"));
		TextView okView = (TextView) findViewById(R.id.custom_alert_ok_text);
		okView.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				dismiss();
			}
		});
		TextView retryView = (TextView) findViewById(R.id.custom_alert_retry_text);
		retryView.setVisibility(View.GONE);
	}
}

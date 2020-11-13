package com.linxy.linxymark.view;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

import com.linxy.linxymark.R;
import com.linxy.linxymark.customui.CustomMainActivity;

public class LoginActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN); //enable full screen
        setContentView(R.layout.activity_login);
    }

    public void onLoginPress(View view)
    {
        startActivity(new Intent(LoginActivity.this, HomeActivity.class));
        finish();
    }

    public void onRegisterPress(View view)
    {
        startActivity(new Intent(LoginActivity.this, RegisterActivity.class));
//        finish();
    }
}

package com.linxy.linxymark.view;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.gun0912.tedpermission.PermissionListener;
import com.gun0912.tedpermission.TedPermission;
import com.linxy.linxymark.R;
import com.linxy.linxymark.customui.CustomMainActivity;

import java.util.List;

public class SplashActivity extends AppCompatActivity {
    private static final int CAMERA_PERMISSION_CODE = 1;


    @SuppressLint("HandlerLeak")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN); //enable full screen
        setContentView(R.layout.activity_splash);
        askPersmission();
    }


    public void askPersmission(){

        PermissionListener permissionlistener = new PermissionListener() {
            @Override
            public void onPermissionGranted() {
                new Handler(){
                    @Override
                    public void handleMessage(Message msg) {
                        super.handleMessage(msg);
//                 Start home activity
//                        startActivity(new Intent(SplashActivity.this, CustomMainActivity.class));
//                 close splash activity
//                        finish();
                    }
                }.sendEmptyMessageDelayed(0,2000);
            }

            @Override
            public void onPermissionDenied(List<String> deniedPermissions) {
                showDialog("Alert", "Camera permission not granted! Can not scan!");
            }
        };

        TedPermission.with(this)
                .setPermissionListener(permissionlistener)
                .setDeniedMessage("If you reject permission,you can not use this service\n\nPlease turn on permissions at [Setting] > [Permission]")
                .setPermissions(Manifest.permission.CAMERA)
                .check();

    }

    private void showDialog(String title, String message) {
        AlertDialog alertDialog = new AlertDialog.Builder(SplashActivity.this).create();
        alertDialog.setTitle(title);
        alertDialog.setMessage(message);
        alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                        askPersmission();
                    }
                });
        alertDialog.show();
    }

    public void onLoginPress(View view)
    {
        startActivity(new Intent(SplashActivity.this, LoginActivity.class));
        finish();
    }

    public void onRegisterPress(View view)
    {
        startActivity(new Intent(SplashActivity.this, RegisterActivity.class));
        finish();
    }
}

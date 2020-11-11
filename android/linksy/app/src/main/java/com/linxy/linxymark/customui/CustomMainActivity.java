package com.linxy.linxymark.customui;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.commit451.modalbottomsheetdialogfragment.ModalBottomSheetDialogFragment;
import com.commit451.modalbottomsheetdialogfragment.Option;
import com.franmontiel.localechanger.utils.ActivityRecreationHelper;
import com.hp.linkreadersdk.AuthenticationCallback;
import com.hp.linkreadersdk.CameraError;
import com.hp.linkreadersdk.CaptureViewCallback;
import com.hp.linkreadersdk.ErrorCode;
import com.hp.linkreadersdk.Injector;
import com.hp.linkreadersdk.LinkReaderCameraView;
import com.hp.linkreadersdk.LinkReaderCaptureManager;
import com.hp.linkreadersdk.LinkReaderManager;
import com.hp.linkreadersdk.LinkReaderSDK;
import com.hp.linkreadersdk.Presenter;
import com.hp.linkreadersdk.enums.CaptureStates;
import com.hp.linkreadersdk.payoff.DetectionCallback;
import com.hp.linkreadersdk.payoff.Payoff;
import com.hp.linkreadersdk.payoff.PayoffError;
import com.hp.linkreadersdk.payoff.ResolveError;
import com.hp.linkreadersdk.payoff.Web;
import com.hp.linkreadersdk.widget.Crosshair;
import com.hp.linkreadersdk.widget.FlashButton;
import com.linxy.linxymark.R;
import com.linxy.linxymark.view.AttibutionActivity;
import com.linxy.linxymark.view.HelpActivity;
import com.linxy.linxymark.view.PrivacyPolicy;
import com.linxy.linxymark.view.WebViewActivity;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.michaelbel.bottomsheet.BottomSheet;

import java.util.Map;

/**
 * This is an example on how to use our headless API calls
 * <p>
 * <p>
 * Camera.PreviewCallback is used to send the preview frames to the sdk via the
 * HeadlessCaptureManager.readImageFrame method. This is demonstrated in the onPreviewFrame callback
 * method
 * <p>
 * DetectionCallback is used to receive feed back regarding mark detection and payoff delivery.
 */

/*
    November 2017

    We have recently discovered a bug in this sample which causes the scanner to stop working.
    To get the scanning to work again you will need to restart the app

    DO NOT just copy and paste this code as you will have the same bug.

    The SimpleSample App will work every time. Please use the SimpleSample App if you do not need the Custom scanning interface.
 */

public class CustomMainActivity extends AppCompatActivity
        implements DetectionCallback, ModalBottomSheetDialogFragment.Listener {

    private static final int CAMERA_PERMISSION_CODE = 1;
    private static String AUTH_STATE = "AUTH_STATE";
    private static String SCAN_STATE = "SCAN_STATE";
    LinkReaderManager linkReaderManager;
    LinkReaderCaptureManager linkReaderCaptureManager;
    private Button startScanButton;
    private AuthState authState = AuthState.AUTHORIZING;
    private boolean isScanning = false;
    private FrameLayout cameraFrame;
    private boolean isPresenting = false;
    private FlashButton flashButton;
    private Crosshair crosshair;

    private CaptureViewCallback getCaptureViewCallback() {
        CaptureViewCallback captureViewCallback = new CaptureViewCallback() {

            @Override
            public void didChangeFromState(CaptureStates fromState, CaptureStates toState) {
                if (toState.equals(CaptureStates.CAMERA_RUNNING) && !fromState.equals(CaptureStates.SCANNER_RUNNING) && !isDialogShowing()) {
                    startScanning();
                }
            }

            @Override
            public void cameraFailedError(CameraError lrCameraError) {
                Log.d("Error", "Camera failed to open");
            }
        };

        return captureViewCallback;
    }

    private void startScanning() {
        linkReaderCaptureManager.startScanning(this);
    }

//    @Override
//    protected void attachBaseContext(Context newBase) {
////        newBase = LocaleChanger.configureBaseContext(newBase);
//     //   super.attachBaseContext(newBase);
//    }


    /**
     * Please read inline comments for details on initialization of SDK
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {

//        LocaleChanger.setLocale(LocaleChanger.getLocale());

        super.onCreate(savedInstanceState);
        //First you will need to call initialize
        LinkReaderSDK.initialize(this);
        setContentView(R.layout.custom_activity_main);
        flashButton = (FlashButton) findViewById(com.hp.linkreadersdk.R.id.flash_button);
        crosshair = (Crosshair) findViewById(com.hp.linkreadersdk.R.id.crosshair);

        //Then you will need to get references to the following objects from the SDK
        linkReaderManager = Injector.getObjectGraph().get(LinkReaderManager.class);
        linkReaderCaptureManager = Injector.getObjectGraph().get(LinkReaderCaptureManager.class);

        if (savedInstanceState != null) {
            linkReaderManager.retrieveState(savedInstanceState);
            linkReaderCaptureManager.retrieveSate(savedInstanceState);
        }

        cameraFrame = (FrameLayout) findViewById(R.id.flContent);

        findViewById(R.id.privacypolicy).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                createPopup();
            }
        });

        LinkReaderCameraView cameraView = new LinkReaderCameraView(this, null);
        cameraFrame.addView(cameraView);

        //Next you will need to get authorization for the SDK using your Client ID and Client Secret from LinkCreationStudio
        //https://mylinks.linkcreationstudio.com/developer/scan-tools/sdk/android-linkreader/

        if (!linkReaderManager.isAuthorized()) {
            setAuthState(AuthState.AUTHORIZING);
            linkReaderManager.authorizeWithClientID(Credentials.CLIENT_ID, Credentials.CLIENT_SECRET, new AuthenticationCallback() {
                @Override
                public void onAuthenticationSuccess() {
                    CustomMainActivity.this.onAuthenticationSuccess();
                }

                @Override
                public void onAuthenticationFailed(ErrorCode errorCode) {
                    CustomMainActivity.this.onAuthenticationError(errorCode);
                }
            }, this);
        } else {


            CustomMainActivity.this.onAuthenticationSuccess();
            linkReaderCaptureManager.setCaptureViewCallback(getCaptureViewCallback());
        }


        if (savedInstanceState == null) {
            setAuthState(AuthState.AUTHORIZING);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED || checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    requestPermissions(new String[]{Manifest.permission.CAMERA, Manifest.permission.ACCESS_FINE_LOCATION}, CAMERA_PERMISSION_CODE);
                } else {
                    CustomMainActivity.this.onAuthenticationSuccess();
                }
            } else {
                CustomMainActivity.this.onAuthenticationSuccess();
            }
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putSerializable(AUTH_STATE, authState);
        outState.putBoolean(SCAN_STATE, isScanning);
    }

    @Override
    public void onBackPressed() {
        linkReaderCaptureManager.stopSession();
        super.onBackPressed();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (isScanning) {
            linkReaderCaptureManager.stopScanning();
            resumeScanning();
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case CAMERA_PERMISSION_CODE:
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    linkReaderCaptureManager.startSession();
                } else {
                    Log.d("Error", "Camera permission denied by user");
                    showDialog("Alert", "Camera permission not granted! Can not scan!");
                }
                break;
        }
    }

    // To be able to scan, the application must be authorized.
    private void onAuthenticationSuccess() {
        setAuthState(AuthState.AUTHORIZED);
        linkReaderCaptureManager.setCaptureViewCallback(getCaptureViewCallback());
        linkReaderCaptureManager.startSession();
    }

    /**
     * The following method is used for error handling of the demo app
     * <p>
     * not required for custom ui
     */
    private void showAuthenticationNetworkFailed() {
        NetworkErrorDialog networkErrorDialog = new NetworkErrorDialog(this);
        networkErrorDialog.show();
        networkErrorDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                reauthenticate();
            }
        });
        networkErrorDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                setAuthState(AuthState.NOT_AUTHORIZED);
            }
        });
    }

    /**
     * The following method is used for error handling of the demo app
     * <p>
     * not required for custom ui
     */
    private void showAuthenticationFailed() {
        AuthenticationErrorDialog authenticationErrorDialog = new AuthenticationErrorDialog(this);
        authenticationErrorDialog.show();
        authenticationErrorDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                setAuthState(AuthState.NOT_AUTHORIZED);
            }
        });
    }

    /**
     * The following method is used for error handling of the demo app
     * <p>
     * not required for custom ui
     */
    private void onAuthenticationError(ErrorCode errorCode) {
        Log.d("Auth", "ErrorCode " + errorCode.name());
        hideProgress();
        if (errorCode == ErrorCode.CONNECTION_ERROR) {
            showAuthenticationNetworkFailed();
        } else {
            showAuthenticationFailed();
        }
    }

    private void showProgress() {
        final ProgressBar progress = (ProgressBar) findViewById(R.id.progress);
        progress.setVisibility(View.VISIBLE);
    }

    private void hideProgress() {
        final ProgressBar progress = (ProgressBar) findViewById(R.id.progress);
        progress.setVisibility(View.INVISIBLE);
    }

    public void reauthenticate() {
        setAuthState(AuthState.AUTHORIZING);
        linkReaderManager.authorizeWithClientID(Credentials.CLIENT_ID, null, new AuthenticationCallback() {
            @Override
            public void onAuthenticationSuccess() {
                CustomMainActivity.this.onAuthenticationSuccess();
            }

            @Override
            public void onAuthenticationFailed(ErrorCode errorCode) {
                CustomMainActivity.this.onAuthenticationError(errorCode);
            }
        }, this);
    }

    /**
     * This method is used to manage the authorization states, it is a good way to identify if you have
     * properly set up Client Id, Client Secret and App registration
     * <p>
     * This is not required to get a Custom UI working
     *
     * @param authorizing
     */
    private void setAuthState(AuthState authorizing) {
        authState = authorizing;
        switch (authorizing) {
            case AUTHORIZING:
                showProgress();
                resetMessage();
                break;
            case AUTHORIZED:
                hideProgress();
                resetMessage();
                if (!isScanning) {
                    isScanning = true;
                    cameraFrame.setVisibility(View.VISIBLE);
                    crosshair.setVisibility(View.VISIBLE);
                }
                break;
            case NOT_AUTHORIZED:
                TextView message = (TextView) findViewById(R.id.message);
                message.setText(R.string.not_authorized);
                hideProgress();
                break;
            case CAMERA_PERMISSION_DENIED:
                message = (TextView) findViewById(R.id.message);
                message.setText(R.string.camera_permission_denied);
                hideProgress();
                break;
            case CAMERA_FAILED:
                message = (TextView) findViewById(R.id.message);
                message.setText(R.string.camera_failed);
                hideProgress();
                final FrameLayout startScanFragment = (FrameLayout) findViewById(R.id.flContent);
                startScanFragment.setVisibility(View.VISIBLE);
                break;
        }
        Log.d("AuthState", authorizing + "");
    }

    private void resetMessage() {
        final TextView message = (TextView) findViewById(R.id.message);
        message.setText("");
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        AuthState authState = (AuthState) savedInstanceState.getSerializable(AUTH_STATE);
        setAuthState(authState);
        isScanning = savedInstanceState.getBoolean(SCAN_STATE);
    }

    /**
     * This method will be called when a processed frame has a payoff associated with a discovered mark
     * you can use payoff.getPayoffType() to determine what kind of payoff it is and react accordingly
     *
     * @param payoff
     */
    @Override
    public void didFindPayoff(final Payoff payoff) {
        crosshair.setVisibility(View.INVISIBLE);
        Log.d("Payoff", payoff.getPayoffType().toString());
        String payoffContent = "";
        Map<String, Object> privateData = payoff.getPrivateData();
        String validity = "Unknown";
        if (privateData != null) {
            validity = (String) privateData.get("validity");
            if (validity == null)
                validity = "Unknown";
        }

        Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
        if (Build.VERSION.SDK_INT >= 26) {
            vibrator.vibrate(VibrationEffect.createOneShot(200, VibrationEffect.DEFAULT_AMPLITUDE));
        } else {
            vibrator.vibrate(200);
        }

        switch (payoff.getPayoffType()) {
            case WEB:
                Web web = (Web) payoff;
                payoffContent = web.getUrl();
                Intent intent = new Intent(CustomMainActivity.this, WebViewActivity.class);
                intent.putExtra(getString(R.string.url), payoffContent);
                startActivity(intent);
                break;
            default:

                Presenter presenter = new Presenter();
                if (presenter.hasPresenter(payoff)) {
                    presenter.presentPayoff(payoff, CustomMainActivity.this);
                }

        }
    }

//    @Override
//    public void didTransitionToState(HeadlessDetector.DETECTOR_STATES state) {
//
//    }

    @Override
    public void didFailWithError(Exception ex) {
        if (ex instanceof ResolveError) {
            errorOnPayoffResolving((ResolveError) ex);
        } else if (ex instanceof PayoffError) {
            payoffError((PayoffError) ex);
        }

    }

    /**
     * These are the two errors that could be called durring the resolving process
     * <p>
     * ResolverError types: NETWORK_ERROR, LINK_NO_LONGER_ACTIVE, LINK_OUT_OF_RANGE,
     * UNEXPECTED, NETWORK_TIMEOUT, UNKNOWN_HOST, HTTP_ERROR;
     * <p>
     * PayoffError types: UNSUPPORTED_TYPE, INVALID_PAYOFF, UNEXPECTED;
     */
    private void errorOnPayoffResolving(ResolveError resolveError) {
        Log.d("ERRORRESOLVING", resolveError.getErrorFromStatusCode().toString());
        showPayoffContentDialog("Error on Payoff Resolving", resolveError.getErrorFromStatusCode().toString(), null);
    }

    private void payoffError(PayoffError payoffError) {
        Log.d("ERROR", payoffError.toString());
        showPayoffContentDialog("Payoff Error", payoffError.getErrorCode().toString(), null);
    }

    /**
     * This method is an example of how to create a simple dialog to show the payoff content
     */
    private void showPayoffContentDialog(String payoffType, String payoffContent, String validity) {
        onDialogShowing();
        Bundle args = new Bundle();
        if (validity != null) {
            payoffContent += "\nValidity: " + validity;
        }
        args.putString("payoff_type", payoffType);
        args.putString("payoff_content", payoffContent);
        PayoffContentDialog payoffContentDialog = new PayoffContentDialog(this, args);
        payoffContentDialog.show();
        payoffContentDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                resumeScanning();
            }
        });
    }

    private void showDialog(String title, String message) {
        AlertDialog alertDialog = new AlertDialog.Builder(CustomMainActivity.this).create();
        alertDialog.setTitle(title);
        alertDialog.setMessage(message);
        alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                });
        alertDialog.show();
    }

    public void resumeScanning() {
        isPresenting = false;
        startScanning();
        crosshair.setVisibility(View.VISIBLE);
    }

    public void onDialogShowing() {
        isPresenting = true;
        linkReaderCaptureManager.stopScanning();
        crosshair.setVisibility(View.INVISIBLE);
    }

    public boolean isDialogShowing() {
        return isPresenting;
    }


    enum AuthState {
        AUTHORIZING, AUTHORIZED, NOT_AUTHORIZED, CAMERA_FAILED, CAMERA_PERMISSION_DENIED
    }


    private void createPopup() {

//        final BottomSheet.Builder builder = new BottomSheet.Builder(this);
//
//
//        builder.setTitleTextColor(getResources().getColor(R.color.black)).setView(R.layout.customview).show();
//        builder.getView().findViewById(R.id.privacypolicy).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                builder.dismiss();
//                startActivity(new Intent(CustomMainActivity.this, PrivacyPolicy.class));
//            }
//        });
//
//        builder.getView().findViewById(R.id.help).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                builder.dismiss();
//                startActivity(new Intent(CustomMainActivity.this, HelpActivity.class));
//            }
//        });
//
//        builder.getView().findViewById(R.id.attribution).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                builder.dismiss();
//                startActivity(new Intent(CustomMainActivity.this, AttibutionActivity.class));
//            }
//        });
//
//        builder.getView().findViewById(R.id.changelanguage).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                builder.dismiss();
//                createLanguagePopup();
//            }
//        });


        new ModalBottomSheetDialogFragment.Builder()
                .add(R.menu.menu_options)
                .header("Select Options",R.layout.modal_bottom_sheet_dialog_fragment_header)
                .show(getSupportFragmentManager(), "HI");

    }

    @Override
    public void onModalOptionSelected(@Nullable String s, @NotNull Option option) {

        switch (option.getId()) {
            case R.id.privacypolicy:
                startActivity(new Intent(CustomMainActivity.this, PrivacyPolicy.class));
                break;
            case R.id.help:
                startActivity(new Intent(CustomMainActivity.this, HelpActivity.class));
                break;
            case R.id.attribution:
                startActivity(new Intent(CustomMainActivity.this, AttibutionActivity.class));
                break;
        }


    }


    private void createLanguagePopup() {


        final BottomSheet.Builder builder = new BottomSheet.Builder(this).setFullWidth(true);
        linkReaderManager = null;

        builder.setTitle("Select Option").setTitleTextColor(getResources().getColor(R.color.black)).setView(R.layout.customview_languague).show();
        builder.getView().findViewById(R.id.english).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                builder.dismiss();
                // LocaleChanger.setLocale(MainApplication.SUPPORTED_LOCALES.get(0));
                ActivityRecreationHelper.recreate(CustomMainActivity.this, true);
            }
        });

        builder.getView().findViewById(R.id.spanish).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                // LocaleChanger.setLocale(MainApplication.SUPPORTED_LOCALES.get(1));
                ActivityRecreationHelper.recreate(CustomMainActivity.this, true);
            }
        });


    }


    @Override
    protected void onDestroy() {
        super.onDestroy();


    }
}
package com.linxy.linxymark.view;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

import com.google.android.material.snackbar.Snackbar;
import com.hp.linkreadersdk.EasyReadingCallback;
import com.hp.linkreadersdk.EasyReadingFragment;
import com.hp.linkreadersdk.Presenter;
import com.hp.linkreadersdk.payoff.Payoff;
import com.hp.linkreadersdk.payoff.Web;
import com.linxy.linxymark.R;
import com.linxy.linxymark.utils.Credentials;
import com.linxy.linxymark.utils.LocaleHelper;
import com.linxy.linxymark.utils.NetworkManager;
import com.linxy.linxymark.utils.Utils;

import org.michaelbel.bottomsheet.BottomSheet;

import static com.hp.linkreadersdk.enums.PayoffType.HTML;
import static com.hp.linkreadersdk.enums.PayoffType.WEB;

//import org.jetbrains.annotations.NotNull;


public class MainActivity extends AppCompatActivity {


    private Utils mUtils;
    private static EasyReadingFragment easyReadingFragment;
    private ImageView mNoNetworkImg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        updateViews("es");
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN); //enable full screen
        setContentView(R.layout.activity_main);
        mUtils = new Utils(this);
        mNoNetworkImg = (ImageView) findViewById(R.id.no_network_image);


        if (savedInstanceState == null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED || checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    requestPermissions(new String[]{Manifest.permission.CAMERA, Manifest.permission.ACCESS_FINE_LOCATION}, 1);
                } else {
                    init();
                }
            } else {
                init();
            }
        }

        findViewById(R.id.img_shutdown).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        findViewById(R.id.privacypolicy).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                createPopup();
            }
        });


    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(LocaleHelper.onAttach(base));
    }

    private void updateViews(String languageCode) {
        Context context = LocaleHelper.setLocale(this, languageCode);
        Resources resources = context.getResources();

    }

    private void createPopup() {

        final BottomSheet.Builder builder = new BottomSheet.Builder(this);


        builder.setTitleTextColor(getResources().getColor(R.color.black)).setView(R.layout.customview).show();
        builder.getView().findViewById(R.id.privacypolicy).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                startActivity(new Intent(MainActivity.this, PrivacyPolicy.class));
            }
        });

        builder.getView().findViewById(R.id.help).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                startActivity(new Intent(MainActivity.this, HelpActivity.class));
            }
        });

        builder.getView().findViewById(R.id.attribution).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                startActivity(new Intent(MainActivity.this, AttibutionActivity.class));
            }
        });

        builder.getView().findViewById(R.id.changelanguage).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                createLanguagePopup();
            }
        });

    }



    private void createLanguagePopup() {

        final BottomSheet.Builder builder = new BottomSheet.Builder(this);


        builder.setTitle("Select Option").setTitleTextColor(getResources().getColor(R.color.black)).setView(R.layout.customview_languague).show();
        builder.getView().findViewById(R.id.english).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                startActivity(new Intent(MainActivity.this, PrivacyPolicy.class));
            }
        });

        builder.getView().findViewById(R.id.spanish).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                builder.dismiss();
                startActivity(new Intent(MainActivity.this, HelpActivity.class));
            }
        });



    }

    private void init() {
        FrameLayout linearLayout = (FrameLayout) findViewById(R.id.linkreader_view);
        if (NetworkManager.isOnline(this)) {
            mNoNetworkImg.setVisibility(View.GONE);



            easyReadingFragment = EasyReadingFragment.initWithClientID(Credentials.CLIENT_ID, Credentials.CLIENT_SECRET, new EasyReadingCallback() {
                @Override
                public void onAuthenticationSuccess() {
                }

                @Override
                public void onAuthenticationError(com.hp.linkreadersdk.ErrorCode errorCode) {
                    Log.d("Auth", "ErrorCode " + errorCode.name());
                    mUtils.showDialog("Alert", getString(R.string.not_authorized));
                }

                @SuppressLint("LongLogTag")
                @Override
                public boolean handlePayoff(final Payoff payoff) {

                    if (payoff.getPayoffType() == WEB) {
                        Web web = (Web) payoff;
                        String payoffContent = web.getUrl();
                        Intent intent = new Intent(MainActivity.this, WebViewActivity.class);
                        intent.putExtra(getString(R.string.url), payoffContent);
                        startActivity(intent);
                        return true;
                    } else if (payoff.getPayoffType() == HTML) {
                        AlertDialog alertDialog = new AlertDialog.Builder(MainActivity.this).create();
                        alertDialog.setTitle("HTML Payoff Retrieved");
                        alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "Present Payoff",
                                new DialogInterface.OnClickListener() {
                                    public void onClick(DialogInterface dialog, int which) {
                                        Presenter presenter = new Presenter();
                                        if (presenter.hasPresenter(payoff)) {
                                            presenter.presentPayoff(payoff, MainActivity.this);
                                        }
                                        dialog.dismiss();
                                    }
                                });
                        alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Continue Scanning",
                                new DialogInterface.OnClickListener() {
                                    public void onClick(DialogInterface dialog, int which) {
                                        dialog.dismiss();
                                    }
                                });
                        alertDialog.show();
                        alertDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                            @Override
                            public void onDismiss(DialogInterface dialog) {
                                easyReadingFragment.resumeScanning();
                            }
                        });
                        return true;
                    }
                    return false;
                }

            }, this);



            FragmentTransaction fragmentTransaction = getSupportFragmentManager().beginTransaction();
            fragmentTransaction.add(linearLayout.getId(), easyReadingFragment).commitAllowingStateLoss();
        } else {
            mNoNetworkImg.setVisibility(View.VISIBLE);
            Snackbar.make(
                    findViewById(R.id.container),
                    R.string.no_network,
                    Snackbar.LENGTH_INDEFINITE)
                    .setAction(R.string.settings, new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            startActivityForResult(new Intent(android.provider.Settings.ACTION_SETTINGS), 101);
                        }
                    })
                    .show();
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            init();
        } else {
            mUtils.showDialog("Alert", getString(R.string.camera_permission_denied));
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == 101) {
            if (NetworkManager.isOnline(this))
                init();
        }
    }

}
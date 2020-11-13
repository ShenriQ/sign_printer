package com.linxy.linxymark.view;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.Toast;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.linxy.linxymark.R;
import com.linxy.linxymark.customui.CustomMainActivity;
import com.linxy.linxymark.fragments.CreateFragment;
import com.linxy.linxymark.fragments.HomeFragment;

public class HomeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN); //enable full screen

        setContentView(R.layout.activity_home);

        goPage("home");

//        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottom_navigation);
//        bottomNavigationView.setSelectedItemId(R.id.action_home);
//        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
//            @Override
//            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
//                switch (item.getItemId()) {
//                    case R.id.action_home:
////                        Toast.makeText(HomeActivity.this, "Home", Toast.LENGTH_SHORT).show();
//                        break;
//                    case R.id.action_scan:
//                        startActivity(new Intent(HomeActivity.this, CustomMainActivity.class));
//                        Toast.makeText(HomeActivity.this, "Scan", Toast.LENGTH_SHORT).show();
//                        break;
//                    case R.id.action_create:
////                        Toast.makeText(HomeActivity.this, "Create", Toast.LENGTH_SHORT).show();
//                        break;
//                    case R.id.action_help:
////                        Toast.makeText(HomeActivity.this, "Help", Toast.LENGTH_SHORT).show();
//                        break;
//                    case R.id.action_user:
////                        Toast.makeText(HomeActivity.this, "User", Toast.LENGTH_SHORT).show();
//                        break;
//                }
//                return true;
//            }
//        });
    }

    public void onScanMarks(View view)
    {
        startActivity(new Intent(HomeActivity.this, CustomMainActivity.class));
    }

    public void onCreateMarks(View view)
    {
        goPage("create");
    }

    public void onHome(View view)
    {
        goPage("home");
    }

    public void onHelp(View view)
    {
        goPage("help");
    }

    public void onUser(View view)
    {
        goPage("user");
    }

    private void goPage(String page)
    {
        Fragment _frag = new Fragment();
        if(page.equals("home"))
        {
            _frag = new HomeFragment();
        }
        else if(page.equals("scan"))
        {
            _frag = new HomeFragment();
        }
        else if(page.equals("create"))
        {
            _frag = new CreateFragment();
        }
        else if(page.equals("help"))
        {
            _frag = new HomeFragment();
        }
        else if(page.equals("user"))
        {
            _frag = new HomeFragment();
        }
        getFragmentManager()
                .beginTransaction()
                .replace(R.id.home_content, _frag)
                .commit();
    }
}

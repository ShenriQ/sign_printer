package com.linxy.linxymark.fragments;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.linxy.linxymark.R;

//import androidx.fragment.app.Fragment;

public class CreateFragment extends Fragment implements View.OnClickListener {

    public CreateFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_create, container, false);
        Button start_btn = view.findViewById(R.id.start_create_btn);
        start_btn.setOnClickListener(this);
        return view;
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.start_create_btn:
                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.home_content, new SelectPhotoFragment())
                        .commit();
                break;
        }
    }
}

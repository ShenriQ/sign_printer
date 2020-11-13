package com.linxy.linxymark.fragments;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.linxy.linxymark.R;

//import androidx.fragment.app.Fragment;

public class UpdateAlmostFragment extends Fragment implements View.OnClickListener {

    public UpdateAlmostFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_update_almost, container, false);
//        Button start_btn = view.findViewById(R.id.next_video_btn);
//        start_btn.setOnClickListener(this);
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
            case R.id.next_video_btn:
                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.home_content, new HomeFragment())
                        .commit();
                break;
        }
    }
}

package com.example.nexus;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

@SuppressLint("NewApi")
public class MasterFragment extends Fragment implements OnClickListener {
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		return inflater.inflate(R.layout.fragment_master, container, false);
	}
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		
		Button mButtonGoogle = (Button) getActivity().findViewById(R.id.button_google);
		mButtonGoogle.setOnClickListener(this);

		Button mButtonBing = (Button) getActivity().findViewById(R.id.button_bing);
		mButtonBing.setOnClickListener(this);
	}
	
	public void onClick(View v) {
		if (MainActivity.isLargeScreen) {
			FragmentTransaction transaction = getFragmentManager().beginTransaction();
			DetailFragment detailFragment = new DetailFragment();
			Bundle args = new Bundle();
			
			switch (v.getId()) {
				case R.id.button_google:
					args.putString("URL", "http://www.google.com/");
					break;
				case R.id.button_bing:
					args.putString("URL", "http://bing.com/");
					break;
			}
			detailFragment.setArguments(args);
			transaction.replace(R.id.detailPane, detailFragment);
			
			transaction.addToBackStack(null);
			
			transaction.commit();
		}
		else {
			Intent intent;
			switch (v.getId()) {
				case R.id.button_google:
					intent = new Intent(getActivity(), DetailActivity.class);
					intent.putExtra("URL",  "http://www.google.com/");
		            getActivity().startActivity(intent);
		            break;
				case R.id.button_bing:
					intent = new Intent(getActivity(), DetailActivity.class);
					intent.putExtra("URL",  "http://bing.com/");
		            getActivity().startActivity(intent);
					break;
			}
		}
	}
}
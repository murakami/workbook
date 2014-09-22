package com.example.nexus;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class DetailFragment extends Fragment {
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle saveInstanceState) {
		super.onCreateView(inflater, container, saveInstanceState);
		View view = inflater.inflate(R.layout.fragment_detail,  container, false);
		
		WebView webView = (WebView)view.findViewById(R.id.detailWebView);
		webView.setWebViewClient(new WebViewClient());
		String url = getArguments().getString("URL");
		webView.loadUrl(url);
		return view;
	}
}
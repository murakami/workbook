package com.example.nexus;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class DetailActivity extends Activity {
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);
        
        WebView webView = (WebView)findViewById(R.id.detailWebView);
        webView.setWebViewClient(new WebViewClient());
        String url = getIntent().getStringExtra("URL");
		webView.loadUrl(url);
    }
}

package com.example.advertisingidentifier

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.ads.identifier.AdvertisingIdClient
import androidx.ads.identifier.AdvertisingIdInfo
import com.google.common.util.concurrent.FutureCallback

// Used for the call to addCallback() within this snippet.
import com.google.common.util.concurrent.Futures.addCallback
import java.util.concurrent.Executors

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("MainActivity", "onCreate")
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        determineAdvertisingInfo()

        val button = findViewById<Button>(R.id.button)
        button.setOnClickListener {
            Log.d("MainActivity", "button # onClickListener")
            determineAdvertisingInfo()
        }
    }

    override fun onStart() {
        Log.d("MainActivity", "onStart")
        super.onStart()

        determineAdvertisingInfo()
    }

    override fun onResume() {
        Log.d("MainActivity", "onResume")
        super.onResume()

        determineAdvertisingInfo()
    }

    private fun determineAdvertisingInfo() {
        if (AdvertisingIdClient.isAdvertisingIdProviderAvailable(this)) {
            Log.d("MainActivity", "isAdvertisingIdProviderAvailable");
            val advertisingIdInfoListenableFuture =
                    AdvertisingIdClient.getAdvertisingIdInfo(applicationContext)

            addCallback(advertisingIdInfoListenableFuture,
                    object : FutureCallback<AdvertisingIdInfo> {
                        override fun onSuccess(adInfo: AdvertisingIdInfo?) {
                            val id: String? = adInfo?.getId()
                            val providerPackageName: String? = adInfo?.getProviderPackageName()
                            val isLimitTrackingEnabled: Boolean? =
                                    adInfo?.isLimitAdTrackingEnabled()
                            Log.d("MainActivity",
                                "id(" + id + ") providerPackageName(" + providerPackageName + ") isLimitTrackingEnabled(" + isLimitTrackingEnabled + ")")
                        }

                        override fun onFailure(t: Throwable) {
                            Log.e("MainActivity",
                                    "Failed to connect to Advertising ID provider.")
                            // Try to connect to the Advertising ID provider again, or fall
                            // back to an ads solution that doesn't require using the
                            // Advertising ID library.
                        }
                    }, Executors.newSingleThreadExecutor())
        } else {
            // The Advertising ID client library is unavailable. Use a different
            // library to perform any required ads use cases.
            Log.d("MainActivity", "not isAdvertisingIdProviderAvailable")
        }
    }
}

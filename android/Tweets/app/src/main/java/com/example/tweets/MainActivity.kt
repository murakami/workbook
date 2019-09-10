package com.example.tweets

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.core.app.ShareCompat
import java.io.File


class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val intentTweetButton: Button = findViewById(R.id.intentTweetButton)
        intentTweetButton.setOnClickListener {
            shareTwitter()
        }

        val shareCompatButton: Button = findViewById(R.id.shareCompatButton)
        shareCompatButton.setOnClickListener {
            shareCompat()
        }
    }

    fun shareTwitter() {
        val message = "shareTwitter intent tweet"
        try {
            val sharingIntent = Intent(Intent.ACTION_SEND)
            sharingIntent.setClassName("com.twitter.android", "com.twitter.android.PostActivity")
            sharingIntent.putExtra(Intent.EXTRA_TEXT, message)
            startActivity(sharingIntent)
        }
        catch (e: Exception) {
            Log.e("In Exception", "Comes here")
            val i = Intent()
            i.putExtra(Intent.EXTRA_TEXT, message)
            i.action = Intent.ACTION_VIEW
            i.data = Uri.parse("https://mobile.twitter.com/compose/tweet")
            startActivity(i)
        }

    }

    fun shareCompat() {
        val message = "shareCompat"
        val builder = ShareCompat.IntentBuilder.from(this)
        builder.setChooserTitle("Choose App")
        builder.setText(message)
        builder.setType("text/plain")
        builder.startChooser()
    }
}

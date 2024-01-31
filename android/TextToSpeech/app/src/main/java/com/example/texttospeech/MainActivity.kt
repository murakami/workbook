package com.example.texttospeech

import android.os.Bundle
import android.speech.tts.TextToSpeech
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.texttospeech.ui.theme.TextToSpeechTheme
import java.util.*

class MainActivity : ComponentActivity(), TextToSpeech.OnInitListener {
    private var textToSpeech: TextToSpeech? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        this.textToSpeech = TextToSpeech(this, this)
        setContent {
            TextToSpeechTheme {
                // A surface container using the 'background' color from the theme
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    Greeting(this.textToSpeech)
                }
            }
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            val locale = Locale.JAPAN
            if (this.textToSpeech!!.isLanguageAvailable(locale) >= TextToSpeech.LANG_AVAILABLE) {
                this.textToSpeech!!.language = Locale.JAPAN
            }
            // this.tts!!.speak("こんにちは", TextToSpeech.QUEUE_FLUSH, null, "utteranceId")
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Greeting(textToSpeech: TextToSpeech?, modifier: Modifier = Modifier) {
    val textValue = rememberSaveable { mutableStateOf("文字列を入力してください。") }
    Column {
        TextField(
            value = textValue.value,
            onValueChange = { textValue.value = it },
            label = { },
            modifier = Modifier.padding(16.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Button(
            onClick = {
                if (textToSpeech != null) {
                    textToSpeech!!.speak(
                        textValue.value,
                        TextToSpeech.QUEUE_FLUSH,
                        null,
                        "utteranceId"
                    )
                }
            }
        ) {
            Text("Say")
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    TextToSpeechTheme {
        Greeting(null)
    }
}
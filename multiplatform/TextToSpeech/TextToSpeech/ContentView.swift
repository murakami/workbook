//
//  ContentView.swift
//  TextToSpeech
//
//  Created by 村上幸雄 on 2024/01/29.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var text = ""
    @State var synthesizer: AVSpeechSynthesizer?
    var body: some View {
        VStack {
            TextField("Input text", text: $text)
            Button(action: {
                // Create an utterance.
                let utterance = AVSpeechUtterance(string: text)
                 
                // Configure the utterance.
                utterance.rate = 0.57
                utterance.pitchMultiplier = 0.8
                utterance.postUtteranceDelay = 0.2
                utterance.volume = 0.8
                 
                // Retrieve the Japanese voice.
                let voice = AVSpeechSynthesisVoice(language: "ja-JP")
                 
                // Assign the voice to the utterance.
                utterance.voice = voice
                 
                // Create a speech synthesizer.
                synthesizer = AVSpeechSynthesizer()
                 
                // Tell the synthesizer to speak the utterance.
                synthesizer!.speak(utterance)
            }) {
                Text("Say")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

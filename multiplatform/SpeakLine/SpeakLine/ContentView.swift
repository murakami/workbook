//
//  ContentView.swift
//  SpeakLine
//
//  Created by 村上幸雄 on 2025/01/21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var text = ""
    private let speechSynth = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                
                // prompt
                if text.isEmpty {
                    Text("Enter text to be spoken...") .foregroundColor(Color.gray)
                        .padding(.horizontal, 6)
                }
            }
            HStack {
                Spacer()
                Button("Stop") {
                    print("stop button clicked")
                    speechSynth.stopSpeaking(at: AVSpeechBoundary.immediate)
                }
                Button("Speak") {
                    if text.isEmpty {
                        print("string from TextEditor is empty")
                    } else {
                        print("string is \(text)")
                        let utterance = AVSpeechUtterance(string: text)
                        let locale = Locale(identifier:Locale.preferredLanguages[0])
                        print("locale is \(locale)")
                        let code = locale.languageCode!
                        print("code is \(code)")
                        utterance.voice = AVSpeechSynthesisVoice(language: code)
                        speechSynth.speak(utterance)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  SpeakLine
//
//  Created by 村上幸雄 on 2025/01/21.
//

import SwiftUI
import AVFoundation

final class Speaker: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    @Published var isSpeaking: Bool = false
    private let speechSynth = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        speechSynth.delegate = self
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        let locale = Locale(identifier:Locale.preferredLanguages[0])
        print("locale is \(locale)")
        let code = locale.languageCode!
        print("code is \(code)")
        utterance.voice = AVSpeechSynthesisVoice(language: code)
        speechSynth.speak(utterance)
    }
    
    func stop() {
        speechSynth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

struct ContentView: View {
    @State private var text = ""
    @ObservedObject private var speaker: Speaker = .init()
    
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
                    speaker.stop()
                }.disabled(!speaker.isSpeaking)
                Button("Speak") {
                    if text.isEmpty {
                        print("string from TextEditor is empty")
                    } else {
                        print("string is \(text)")
                        speaker.speak(text)
                    }
                }.disabled(speaker.isSpeaking)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

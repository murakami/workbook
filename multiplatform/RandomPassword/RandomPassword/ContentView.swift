//
//  ContentView.swift
//  RandomPassword
//
//  Created by 村上幸雄 on 2024/12/27.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    var body: some View {
        VStack {
            Text(text)
            
            Button("Generate Password") {
                let length = 8
                let password = generateRandomString(length: length)
                text = password
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

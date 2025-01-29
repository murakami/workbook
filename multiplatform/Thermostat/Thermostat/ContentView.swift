//
//  ContentView.swift
//  Thermostat
//
//  Created by 村上幸雄 on 2025/01/29.
//

import SwiftUI

struct ContentView: View {
    @State private var internalTemperature: Double = 68.0
    @State private var isOn = true
    var body: some View {
        HStack {
            VStack {
                Slider(value: $internalTemperature, in: 0 ... 212, step: 1.0)
                    .disabled(!isOn)
                Text(String(format: "%.0lf", internalTemperature))
            }
            .padding()
            VStack {
                Spacer()
                Button("Warmer") {
                    internalTemperature += 1.0
                }
                .disabled(!isOn)
                Spacer()
                Button("Cooler") {
                    internalTemperature += -1.0
                }
                .disabled(!isOn)
                Spacer()
                Button("Power") {
                    isOn = !isOn
                }
                .buttonStyle(.borderless)
            }
            .padding()
        }.padding()
    }
}

#Preview {
    ContentView()
}

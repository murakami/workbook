//
//  ContentView.swift
//  RGBWell
//
//  Created by 村上幸雄 on 2025/01/06.
//

import SwiftUI
import Observation

#if os(iOS)
typealias MyColor = UIColor
#elseif os(macOS)
typealias MyColor = NSColor
#else
#error("your os is not supported")
#endif

extension MyColor {
    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}

extension Color {
    var rgbValues:(red: Double, green: Double, blue: Double){
        let rgba = MyColor(self).rgba
        return (rgba.red, rgba.green, rgba.blue)
    }
}

@Observable
final class MyData {
    var color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    var red = 0.98
    var green = 0.9
    var blue = 0.2
}

struct ContentView: View {
    @State private var myData = MyData()

    var body: some View {
        HStack {
            ColorPicker("", selection: $myData.color)
            VStack {
                HStack {
                    Text("R")
                    Slider(
                        value: $myData.red,
                        in: 0.0...1.0
                    ).disabled(true)
                }
                HStack {
                    Text("G")
                    Slider(
                        value: $myData.green,
                        in: 0.0...1.0
                    ).disabled(true)
                }
                HStack {
                    Text("B")
                    Slider(
                        value: $myData.blue,
                        in: 0.0...1.0
                    ).disabled(true)
                }
            }
            .padding()
        }.padding().onAppear {
            trackingColor(myData)
        }
    }
    
    nonisolated private func trackingColor(_ myData: MyData) {
        withObservationTracking {
            _ = myData.color
        } onChange: {
            let rgb = myData.color.rgbValues
            myData.red = rgb.red
            myData.green = rgb.green
            myData.blue = rgb.blue
            trackingColor(myData)
        }
    }
}

#Preview {
    ContentView()
}

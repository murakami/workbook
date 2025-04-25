//
//  RaiseManApp.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2025/02/10.
//

import SwiftUI

@main
struct RaiseManApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: RaiseManDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}

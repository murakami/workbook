//
//  AppDelegate.swift
//  Temperature
//
//  Created by 村上幸雄 on 2019/07/20.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var preferencesWindowController : NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showPreferencesWindow(_ sender: Any?) {
        if NSApplication.shared.mainWindow?.title == "Preferences" {
            NSApplication.shared.mainWindow?.close()
        }
        else {
            if preferencesWindowController == nil {
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                preferencesWindowController = storyboard.instantiateController(withIdentifier: "PrefsWindow") as? NSWindowController
            }
            
            if preferencesWindowController != nil {
                preferencesWindowController!.showWindow(sender)
                
            }
        }
    }
    
}


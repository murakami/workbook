//
//  AppDelegate.swift
//  DistributedServer
//
//  Created by 村上幸雄 on 2015/12/22.
//  Copyright © 2015年 村上幸雄. All rights reserved.
//

import Foundation
import Cocoa

protocol RemoteObjectProtocol {
    func receiveString(string: String)
}

class AppDelegate: NSObject, NSApplicationDelegate, RemoteObjectProtocol {
    
    @IBOutlet var window: NSWindow?
    @IBOutlet var label: NSTextField?
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        debugPrint(__FUNCTION__)
        _registerForNotes()
        _registerForDistributedObjects()
    }
    
    func _registerForNotes() {
        debugPrint(__FUNCTION__)
        let dnc = NSDistributedNotificationCenter.defaultCenter()
        dnc.addObserver(self, selector: "_handleDistributedNote:", name: "DemoDistributedNote", object: nil)
    }
    
    func _handleDistributedNote(note: NSNotification) {
        debugPrint(__FUNCTION__, "Recieived Distributed Notification!:", note)
        if let label = self.label {
            label.stringValue = "Recieived Distributed Notification!"
        }
    }
    
    func _registerForDistributedObjects() {
        debugPrint(__FUNCTION__)
        /*
        let conn = NSConnection.defaultConnection()
        conn.rootObject = self
        if !conn.registerName("DistributedServer") {
            debugPrint(__FUNCTION__, "error")
        }
        */
    }
    
    func receiveString(string: String) {
        debugPrint(__FUNCTION__)
        if let label = self.label {
            label.stringValue = string
        }
    }
}

/* End Of File */
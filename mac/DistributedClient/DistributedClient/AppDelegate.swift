//
//  AppDelegate.swift
//  DistributedClient
//
//  Created by 村上幸雄 on 2015/12/22.
//  Copyright © 2015年 村上幸雄. All rights reserved.
//

import Foundation
import Cocoa

protocol RemoteObjectProtocol {
    func receiveString(string: String)
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow?
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        debugPrint(__FUNCTION__)
        // _postNotes()
    }
    
    @IBAction func postNotes(sender: AnyObject) {
        debugPrint(__FUNCTION__)
        _postNotes()
    }
    
    @IBAction func postForDistributedObjects(sender: AnyObject) {
        debugPrint(__FUNCTION__)
        _postForDistributedObjects()
    }
    
    func _postNotes() {
        debugPrint(__FUNCTION__)
        let dnc = NSDistributedNotificationCenter.defaultCenter()
        dnc.postNotificationName("DemoDistributedNote", object: nil)
    }
    
    func _postForDistributedObjects() {
        debugPrint(__FUNCTION__)
        /*
        let remoteObject = NSConnection.rootProxyForConnectionWithRegisteredName("DistributedServer", host: "")
        remoteObject.setProtocolForProxy("RemoteObjectProtocol")
        remoteObject.receiveString(NSDate.date().description)
        */
    }
    
}

/* End Of File */
//
//  Document.swift
//  GettingThingsDone
//
//  Created by 村上幸雄 on 2017/12/16.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import EventKit
import Foundation

class Document {
    var version: String
    
    private var _uniqueIdentifier: String
    var uniqueIdentifier: String {
        return _uniqueIdentifier
    }
    
    static let sharedInstance: Document = {
        let instance = Document()
        return instance
    }()
    
    init() {
        let infoDictionary = Bundle.main.infoDictionary! as Dictionary
        self.version = infoDictionary["CFBundleShortVersionString"]! as! String
        self._uniqueIdentifier = ""
    }
    
    deinit {
    }
    
    func load() {
        loadDefaults()
    }
    
    func save() {
        updateDefaults()
    }
    
    private func clearDefaults() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "version") != nil {
            userDefaults.removeObject(forKey: "version")
        }
        if userDefaults.object(forKey: "uniqueIdentifier") != nil {
            userDefaults.removeObject(forKey: "uniqueIdentifier")
        }
    }
    
    private func updateDefaults() {
        let userDefaults = UserDefaults.standard
        
        var versionString: String = ""
        if userDefaults.object(forKey: "version") != nil {
            versionString = userDefaults.object(forKey: "version") as! String
        }
        if versionString.compare(self.version) != .orderedSame {
            userDefaults.setValue(self.version, forKey: "version")
            userDefaults.synchronize()
        }
        
        var uniqueIdentifier: String = ""
        if userDefaults.object(forKey: "uniqueIdentifier") != nil {
            uniqueIdentifier = userDefaults.object(forKey: "uniqueIdentifier") as! String
        }
        if uniqueIdentifier.compare(self.uniqueIdentifier) != .orderedSame {
            userDefaults.setValue(self.uniqueIdentifier, forKey: "uniqueIdentifier")
            userDefaults.synchronize()
        }
    }
    
    private func loadDefaults() {
        let userDefaults = UserDefaults.standard
        
        var versionString: String = ""
        if userDefaults.object(forKey: "version") != nil {
            versionString = userDefaults.object(forKey: "version") as! String
        }
        if versionString.compare(self.version) != .orderedSame {
            /* バージョン不一致対応 */
            clearDefaults()
            _uniqueIdentifier = UUID.init().uuidString
        }
        else {
            /* 読み出し */
            if userDefaults.object(forKey: "uniqueIdentifier") != nil {
                _uniqueIdentifier = userDefaults.object(forKey: "uniqueIdentifier") as! String
            }
        }
    }
    
    private func modelDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count < 1 {
            return ""
        }
        var path = paths[0]
        
        path = path.appending(".model")
        return path
    }
    
    private func modelPath() -> String {
        let path = modelDir().appending("/model.dat")
        return path;
    }
    
    public func demo() {
        /* イベントストアへの接続 */
        let store = EKEventStore()
        let status = EKEventStore.authorizationStatus(for: .event)
        var isAuth = false
        switch status {
        case .notDetermined:
            isAuth = false
        case .restricted:
            isAuth = false
        case .denied:
            isAuth = false
        case .authorized:
            isAuth = true
        }
        if !isAuth {
            store.requestAccess(to: .event, completion: {
                (granted, error) in
                if granted {
                }
                else {
                    return
                }
            })
        }
        
        /* イベントの登録 */
        let event = EKEvent(eventStore: store)
        event.title = "BUKURO.swift 2017-12"
        event.startDate = Calendar.current.date(from: DateComponents(year: 2017, month: 12, day: 6, hour: 19, minute: 30, second: 00))
        event.endDate = Calendar.current.date(from: DateComponents(year: 2017, month: 12, day: 6, hour: 22, minute: 00, second: 00))
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
        }
        catch let error {
            print(error)
        }
        /* イベントの検索 */
        let startDate = Calendar.current.date(from: DateComponents(year: 2017, month: 12, day: 1, hour: 00, minute: 00, second: 00))
        let endDate = Calendar.current.date(from: DateComponents(year: 2017, month: 12, day: 31, hour: 23, minute: 59, second: 59))
        let defaultCalendar = store.defaultCalendarForNewEvents
        let predicate = store.predicateForEvents(withStart: startDate!, end: endDate!, calendars: [defaultCalendar!])
        var events = store.events(matching: predicate)
        print(events)

        /* イベントの削除 */
        do {
            try store.remove(event, span: .thisEvent)
        } catch let error {
            print(error)
        }
        /* イベントの検索 */
        events = store.events(matching: predicate)
        print(events)
    }
}

/* End Of File */

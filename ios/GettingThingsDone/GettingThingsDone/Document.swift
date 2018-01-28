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
    
    let eventStore = EKEventStore()
    
    public func demoEvent() {
        /* イベントストアへの接続 */
        //let eventStore = EKEventStore()
        
        /* イベント追加の権限取得 */
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
            eventStore.requestAccess(to: .event, completion: {
                (granted, error) in
                if granted {
                }
                else {
                    /* 使用拒否 */
                    return
                }
            })
        }
        
        /* イベントの登録 */
        let event = EKEvent(eventStore: eventStore)
        event.title = "BUKURO.swift 2019-01"
        event.startDate = Calendar.current.date(from: DateComponents(year: 2019, month: 1, day: 10, hour: 19, minute: 30, second: 00))
        event.endDate = Calendar.current.date(from: DateComponents(year: 2019, month: 1, day: 10, hour: 22, minute: 00, second: 00))
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
        }
        catch let error {
            print(error)
        }
        /* イベントの検索 */
        let startDate = Calendar.current.date(from: DateComponents(year: 2019, month: 1, day: 1, hour: 00, minute: 00, second: 00))
        let endDate = Calendar.current.date(from: DateComponents(year: 2019, month: 1, day: 31, hour: 23, minute: 59, second: 59))
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        let predicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate!, calendars: [defaultCalendar!])
        var events = eventStore.events(matching: predicate)
        print(events)

        /* イベントの削除 */
        do {
            try eventStore.remove(event, span: .thisEvent)
        }
        catch let error {
            print(error)
        }
        /* イベントの検索 */
        events = eventStore.events(matching: predicate)
        print(events)
    }
    
    public func demoReminder() {
        /* イベントストアへの接続 */
        //let eventStore = EKEventStore()

        /* リマインダー追加の権限取得 */
        let status = EKEventStore.authorizationStatus(for: .reminder)
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
            eventStore.requestAccess(to: .event, completion: {
                (granted, error) in
                if granted {
                    print("付与された")
                }
                else {
                    print(error ?? "no error")
                    print("使用拒否")
                    return
                }
            })
        }
        
        /* リマインダーの登録 */
        let reminder = EKReminder(eventStore: eventStore)
        let calendars = eventStore.calendars(for: .reminder)
        for cal in calendars {
            print(cal)
        }
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        reminder.title = "BUKURO.swift"
        /*
        let startDateComponents = NSDateComponents()
        startDateComponents.year = 2019
        startDateComponents.month = 1
        startDateComponents.day = 1
        startDateComponents.hour = 23
        startDateComponents.minute = 30
        startDateComponents.second = 0
        reminder.startDateComponents = startDateComponents as DateComponents
        let dueDateComponents = NSDateComponents()
        dueDateComponents.year = 2019
        dueDateComponents.month = 1
        dueDateComponents.day = 2
        dueDateComponents.hour = 1
        dueDateComponents.minute = 30
        dueDateComponents.second = 0
        reminder.dueDateComponents = dueDateComponents as DateComponents
         */
        //reminder.isCompleted = false
        //reminder.priority = 0
        do {
            try eventStore.save(reminder, commit: true)
        }
        catch let error {
            print(error)
        }
        
        /* リマインダーの検索 */
        let startDate = Calendar.current.date(from: DateComponents(year: 2018, month: 1, day: 1, hour: 00, minute: 00, second: 00))
        let endDate = Calendar.current.date(from: DateComponents(year: 2019, month: 1, day: 31, hour: 23, minute: 59, second: 59))
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        let predicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: startDate!, ending: endDate!, calendars: [defaultCalendar!])
        eventStore.fetchReminders(matching: predicate, completion: {
            (reminders) in
            for reminder in reminders! {
                print(reminder)
            }
        })

        /* リマインダーの削除 */
        do {
            try eventStore.remove(reminder, commit: true)
        }
        catch let error {
            print(error)
        }
        
        /* リマインダーの検索 */
        eventStore.fetchReminders(matching: predicate, completion: {
            (reminders) in
            for reminder in reminders! {
                print(reminder)
            }
        })
    }
}

/* End Of File */

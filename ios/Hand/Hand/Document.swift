//
//  Document.swift
//  Hand
//
//  Created by 村上幸雄 on 2016/11/21.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

struct Card {
    public var title: String = ""
    
    public init(title: String) {
        self.title = title
    }
}

struct Deck {
    public func nextCard() -> Card {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let card = Card(title: formatter.string(from: today))
        return card
    }
}

protocol DataType {
    var numberOfItems: Int {get}
    func addNewItem(at index: Int) -> Self
    func deleteItem(at index: Int) -> Self
    func moveItem(fromIndex: Int, toIndex: Int) -> Self
}

struct Hand: DataType {
    private var deck = Deck()
    private var cards = [Card]()
    
    public init() {
    }
    
    public init(deck: Deck, cards: [Card]) {
        self.deck = deck
        self.cards = cards
    }
    
    public var numberOfItems: Int {
        return cards.count
    }
    
    public func addNewItem(at index: Int) -> Hand {
        return insertCard(card: deck.nextCard(), at: index)
    }
    
    private func insertCard(card: Card, at index: Int) -> Hand {
        var mutableCards = cards
        mutableCards.insert(card, at: index)
        return Hand(deck: deck, cards: mutableCards)
    }
    
    public func deleteItem(at index: Int) -> Hand {
        var mutableCards = cards
        mutableCards.remove(at: index)
        return Hand(deck: deck, cards: mutableCards)
    }
    
    public func moveItem(fromIndex: Int, toIndex: Int) -> Hand {
        return deleteItem(at: fromIndex).insertCard(card: cards[fromIndex], at: toIndex)
    }
    
    subscript(index: Int) -> Card {
        return cards[index]
    }
}

class Document: NSObject {
    var version: String
    
    private var _uniqueIdentifier: String
    var uniqueIdentifier: String {
        return _uniqueIdentifier
    }
    
    static let sharedInstance: Document = {
        let instance = Document()
        return instance
    }()
    
    private override init() {
        let infoDictionary = Bundle.main.infoDictionary! as Dictionary
        self.version = infoDictionary["CFBundleShortVersionString"]! as! String
        
        self._uniqueIdentifier = ""
    }
    
    private var dataObject: DataType = Hand()
    
    var conditionForAdding: Bool {
        return dataObject.numberOfItems < 5
    }
    
    public var numberOfItems: Int {
        return dataObject.numberOfItems
    }
    
    public func addNewItem(at index: Int) {
        dataObject = dataObject.addNewItem(at: index)
    }
    
    public func getItem(at index: Int) -> Card {
        guard let hand = dataObject as? Hand else {
            fatalError("Could not create Card Cell or Hand instance")
        }
        return hand[index]
    }
    
    public func deleteCard(at index: Int) {
        dataObject = dataObject.deleteItem(at: index)
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
}

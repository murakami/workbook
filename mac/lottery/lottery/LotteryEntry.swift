//
//  LotteryEntry.swift
//  lottery
//
//  Created by 村上幸雄 on 2017/02/05.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation
import GameplayKit

class LotteryEntry {
    var entryDate: Date
    
    private var _firstNumber: Int
    var firstNumber: Int {
        return _firstNumber
    }
    
    private var _secondNumber: Int
    var secondNumber: Int {
        return _secondNumber
    }
    
    init() {
        self.entryDate = Date()
        self._firstNumber = 0
        self._secondNumber = 0
    }
    
    deinit {
        print("Destroying \(self)")
    }
    
    func description() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: entryDate)
        return "\(date) = \(firstNumber) and \(secondNumber)"
    }
    
    func setNumbersRandomly() {
        self._firstNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 99) + 1
        self._secondNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 99) + 1
    }
}

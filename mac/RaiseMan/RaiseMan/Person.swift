//
//  Person.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2017/03/21.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

class Person: NSObject {
    public var personName: String = "New Employee"
    public var expectedRaise: Float = 0.0
    
    override func setNilValueForKey(_ key: String) {
        if key == "expectedRaise" {
            self.expectedRaise = 0.0
        }
        else {
            super.setNilValueForKey(key)
        }
    }
}

//
//  Person.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2017/03/21.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {
    public var personName: String = "New Employee"
    public var expectedRaise: Float = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        self.personName = aDecoder.decodeObject() as! String
        self.expectedRaise = aDecoder.decodeFloat(forKey: "expectedRaise")
    }
    
    override func setNilValueForKey(_ key: String) {
        if key == "expectedRaise" {
            self.expectedRaise = 0.0
        }
        else {
            super.setNilValueForKey(key)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(personName)
        aCoder.encode(expectedRaise, forKey: "expectedRaise")
    }
}

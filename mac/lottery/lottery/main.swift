//
//  main.swift
//  lottery
//
//  Created by 村上幸雄 on 2017/01/30.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

var array = [LotteryEntry]()
for i in 0..<10 {
    /*
    let number = i * 3
    array.append(number)
    */
    var entry = LotteryEntry()
    entry.setNumbersRandomly()
    entry.entryDate = Date(timeIntervalSinceNow: (60.0 * 60.0 * 24.0 * 7.0 * Double(i)))
    array.append(entry)
}
print(array)
for entry in array {
    print(entry.description())
}

exit(EXIT_SUCCESS)

/* End Of File */

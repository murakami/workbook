//
//  Parser.swift
//  pl0
//
//  Created by 村上幸雄 on 2019/01/20.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Foundation

class Parser {
    var ch: Character = "\0"
    var lineString: String = ""
    
    init() {
        readChar()
        S()
    }
    
    func readChar() {
        lineString = readLine()!
        ch = lineString[lineString.index(lineString.startIndex, offsetBy:0)]
        lineString = String(lineString.suffix(lineString.count - 1))
    }
    
    /*
     開式記号に対応する手続き。
     */
    func S() {
    }
}

/* End Of File */

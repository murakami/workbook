//
//  Parser.swift
//  pl0
//
//  Created by 村上幸雄 on 2019/01/20.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Foundation

/* 分析子 */
class Parser {
    var ch: Character = "\0"
    var lineString: String = ""
    let empty: Character = "\0"
    
    class Node {
        public var successor: Node? = nil
        public var alternative: Node? = nil
        public var terminal: Bool = true
        public var terminalSymbol: Character = "\0"
        public var nonterminalSymbol: Header? = nil
    }
    
    class Header {
        public var symbol: Character = "\0"
        public var entry: Node? = nil
    }
    
    init() {
        print("\(#function)")
        readChar()
        A()
    }
    
    func parse(goal: Header, match: inout Bool) {
        var s: Node? = goal.entry
        repeat {
            if s!.terminal {
                if s!.terminalSymbol == ch {
                    match = true
                    readChar()
                }
                else {
                    if s!.terminalSymbol == empty {
                        match = true
                    }
                    else {
                        match = false
                    }
                }
            }
            else {
                parse(goal: s!.nonterminalSymbol!, match: &match)
            }
            if match {
                s = s!.successor
            }
            else {
                s = s!.alternative
            }
        } while s != nil
    }
    
    func A() {
        //print("\(#function)")
        if ch == "x" {
            readChar()
        }
        else if ch == "(" {
            readChar()
            A()
            while ch == "+" {
                readChar()
                A()
            }
            if ch == ")" {
                readChar()
            }
            else {
                error()
            }
        }
        else {
            error()
        }
    }

    func readChar() {
        if lineString.count <= 0 {
            lineString = readLine()!
        }
        ch = lineString[lineString.index(lineString.startIndex, offsetBy:0)]
        lineString = String(lineString.suffix(lineString.count - 1))
        print(ch)
    }
    
    func error() {
        print("error: \(#function)")
        exit(-1)
    }
}

/* End Of File */

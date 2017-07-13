//
//  Semantic.swift
//  Semantic
//
//  Created by 村上幸雄 on 2017/06/27.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

class Semantic {
    class Slot {
        public var name: String
        public var filler: String
        init() {
            self.name = String()
            self.filler = String()
        }
    }
    
    class Node {
        public var name: String
        public var linkInstanceArray: Array<String>
        public var linkSubclassArray: Array<String>
        public var linkSlotArray: Array<Slot>
        
        init() {
            self.name = String()
            self.linkInstanceArray = Array<String>()
            self.linkSubclassArray = Array<String>()
            self.linkSlotArray = Array<Slot>()
        }
    }
    
    var nodeDict: [String : Node]
    
    init() {
        nodeDict = [String : Node]()
    }
    
    /*
     対象物を見つける。
     */
    func find(name: String) -> Node? {
        return nodeDict[name]
    }
    
    /*
     対象物を追加する。
     */
    func addNode(name: String) {
        if find(name: name) == nil {
            let node = Node()
            node.name = name
            nodeDict[name] = node
        }
    }
    
    /*
     対象物にリンクを追加する。
     */
    func addLinkInstance(node: Node, name: String) {
        for linkInstance in node.linkInstanceArray {
            if linkInstance == name {
                return
            }
        }
        node.linkInstanceArray.append(name)
    }
    func addLinkSubclass(node: Node, name: String) {
        for linkSubclass in node.linkSubclassArray {
            if linkSubclass == name {
                return
            }
        }
        node.linkSubclassArray.append(name)
    }
    func addLinkSlot(node: Node, name: String, filler: String) {
        for linkSlot in node.linkSlotArray {
            if (linkSlot.name == name) && (linkSlot.filler == filler) {
                return
            }
        }
        let slot = Slot()
        slot.name = name
        slot.filler = filler
        node.linkSlotArray.append(slot)
    }
    
    /*
     対象物のリンクを印字する。
     */
    func describeNode(node: Node) {
        for inst in node.linkInstanceArray {
            print("    INST " + inst)
        }
        for subc in node.linkSubclassArray {
            print("    SUBC " + subc)
        }
        for slot in node.linkSlotArray {
            print("    SLOT " + slot.name + ", " + slot.filler)
        }
    }
    
    /*
     対象物の特定タイプのリンクを見つける。
     */
    func getLinkInstance(node: Node) -> Array<String> {
        return node.linkInstanceArray
    }
    func getLinkSubclass(node: Node) -> Array<String> {
        return node.linkSubclassArray
    }
    func getLinkSlot(node: Node) -> Array<Slot> {
        return node.linkSlotArray
    }
    
    /*
     対象物の特定スロットの内容を見つける。
     */
    func getSlot(node: Node, slotName: String) -> Array<String> {
        var fillerArray = Array<String>()
        for linkSlot in node.linkSlotArray {
            if linkSlot.name == slotName {
                fillerArray.append(linkSlot.filler)
            }
        }
        return fillerArray
    }
    
    /*
     対象物の特定スロットの継承されている内容を見つける。
     VIP (Value Inhefitance Procedure)
     */
    func valueInherit(node: Node, slotName: String) -> String? {
        var nodeArray = Array<Node>()
        nodeArray.append(node)
        for linkInstance in node.linkInstanceArray {
            if let node = nodeDict[linkInstance] {
                nodeArray.append(node)
            }
        }
        return subInherit(nodeArray: nodeArray, slotName: slotName)
    }
    
    private func subInherit(nodeArray: Array<Node>, slotName: String) -> String? {
        for node in nodeArray {
            for linkSlot in node.linkSlotArray {
                if linkSlot.name == slotName {
                    return linkSlot.filler
                }
            }
            var subclassArray = Array<Node>()
            for linkSubclass in node.linkSubclassArray {
                if let subclass = nodeDict[linkSubclass] {
                    subclassArray.append(subclass)
                }
            }
            if let filler = subInherit(nodeArray: subclassArray, slotName: slotName) {
                return filler
            }
        }
        return nil
    }
}

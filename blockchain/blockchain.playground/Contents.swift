//: Playground - noun: a place where people can play

//#!/usr/bin/env xcrun swift

import Foundation
import Cocoa

struct Block: Codable {
    let index: Int  /* 1, 2, ... */
    let timestamp: Double   /* Date().timeIntervalSince1970 */
    let transactions: [Transaction]
    let proof: Int
    let previousHash: Data
    
    func hash() -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return data.sha256()!
    }
}

struct Transaction: Codable {
    let sender: String
    let recipient: String
    let amount: Int
}

extension Data {
    // https://stackoverflow.com/questions/25388747/sha256-in-swift
    func sha256() -> Data? {
        /*
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((self as NSData).bytes, CC_LONG(self.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
        */
        var hashData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = hashData.withUnsafeMutableBytes {digestBytes in
            self.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return hashData
    }
}

class Blockchain {
    var chain: [Block] = []
    var currentTransactions: [Transaction] = []
    
    init() {
        newBlock(proof: 100, previousHash: "1".data(using: .utf8))
    }
    
    func newBlock(proof: Int, previousHash: Data? = nil) -> Block {
        let prevHash: Data
        if let previousHash = previousHash {
            /* ジェネシスブロックの場合なのか？ */
            prevHash = previousHash
        } else {
            // 前のブロックのハッシュ
            prevHash = lastBlock().hash()
        }
        let block = Block(index: chain.count+1,
                          timestamp: Date().timeIntervalSince1970,
                          transactions: currentTransactions,    /* 複数のトランザクションがあり得る？ */
                          proof: proof,
                          previousHash: prevHash)
        
        // 現在のトランザクションリストをリセット
        currentTransactions = []
        
        chain.append(block)
        
        return block
    }
    
    /*
     新しいトランザクションをリストに加えた後、
     そのトランザクションが加えられるブロック(次に採掘されるブロック)のインデックスを返す.
     */
    func newTransaction(sender: String, recipient: String, amount: Int) -> Int {
        /* 次に採掘されるブロックに加える新しいトランザクションを作る */
        let transaction = Transaction(
            sender: sender,         /* 送信者のアドレス */
            recipient: recipient,   /* 受信者のアドレス */
            amount: amount)         /* 量 */
        currentTransactions.append(transaction)
        
        /* このトランザクションを含むブロックのアドレス */
        return lastBlock().index + 1    /* 次に追加するブロックの索引 */
    }
    
    func lastBlock() -> Block {
        guard let last = chain.last else {  /* 配列の最後の要素 */
            fatalError("The chain should have at least one block as a genesis.")
        }
        return last
    }
    
    func proofOfWork(lastProof: Int) -> Int {
        var proof: Int = 0
        while validProof(lastProof: lastProof, proof: proof) == false {
            proof += 1
        }
        return proof
    }
    
    func validProof(lastProof: Int, proof: Int) -> Bool {
        let proofArray = [lastProof, proof]
        let encoder = JSONEncoder()
        let guess = try! encoder.encode(proofArray)
        let guessHash = guess.sha256()!
        if let data: NSData = guessHash {
            var buffer = Array<Int8>(count: data.length, repeatedValue: 0)
            data.getBytes(&buffer, length: data.length)
            return buffer[0] == 0 && buffer[1] == 0 && buffer[2] == 0 && buffer[3] == 0
        }
        return  false
    }
}

/* End Of File */

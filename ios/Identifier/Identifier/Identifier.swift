//
//  Identifier.swift
//  Identifier
//
//  Created by 村上幸雄 on 2017/05/07.
//  Copyright © 2017年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

class Identifier {
    public static let sharedInstance = Identifier()
    public var uuid: String {
        return getUUID()
    }
    private static let IDENTIFIER_KEY = "jp.co.bitz.Example.IdentifierKey"
    private let service: String
    
    init() {
        if let service = Bundle.main.bundleIdentifier {
            self.service = service
        }
        else {
            self.service = ""
        }
    }
    
    private func getUUID() -> String {
        var uuidString = ""
        
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword       /* パスワードクラス */
        query[kSecAttrService as String] =  self.service as AnyObject?    /* サービス名 */
        query[kSecAttrAccount as String] = Identifier.IDENTIFIER_KEY as AnyObject?  /* アカウント */
        query[kSecMatchLimit as String] = kSecMatchLimitOne         /* 取得する結果の最大件数を1検討する */
        query[kSecReturnAttributes as String] = kCFBooleanTrue      /* 結果を辞書で受け取る（属性値） */
        query[kSecAttrSynchronizable as String] = kCFBooleanTrue    /* iCloud同期 */
        
        var result = noErr
        /* 検索 */
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            result = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        print("status[\(status)]")
        if result == noErr {
            var valueQuery = [String : AnyObject]()
            valueQuery[kSecClass as String] = kSecClassGenericPassword
            valueQuery[kSecReturnData as String] = kCFBooleanTrue   /* 検索をデータで受け取る（パスワード） */
            
            var valueQueryResult: AnyObject?
            let valueStatus = withUnsafeMutablePointer(to: &valueQueryResult) {
                SecItemCopyMatching(valueQuery as CFDictionary, UnsafeMutablePointer($0))
            }
            print("valueStatus[\(valueStatus)]")
            if result == noErr {
                if let passwordData = valueQueryResult as? Data {
                    if let password = String(data: passwordData, encoding: String.Encoding.utf8) {
                        uuidString = password
                    }
                }
            }
        }
        
        if uuidString.isEmpty {
            uuidString = NSUUID().uuidString
            
            var query = [String : AnyObject]()
            query[kSecClass as String] = kSecClassGenericPassword       /* パスワードクラス */
            query[kSecAttrService as String] = self.service as AnyObject?    /* サービス名 */
            query[kSecAttrAccount as String] = Identifier.IDENTIFIER_KEY as AnyObject?    /* アカウント */
            query[kSecAttrLabel as String] = "UUID" as AnyObject?  /* ユーザへ表示する文字列 */
            query[kSecAttrDescription as String] = "a universally unique identifier." as AnyObject? /* アイテムの説明 */
            query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock as AnyObject?  /* 再起動後最初のアンロック以降 次の再起動まで */
            query[kSecValueData as String] = uuidString as AnyObject?
            query[kSecAttrCreationDate as String] = Date() as AnyObject?
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue    /* iCloud同期 */
            
            /* 登録 */
            let result = SecItemAdd(query as CFDictionary, nil)
            if result == noErr {
                print("[ERROR] Couldn't add the Keychain Item. result = \(result) query = \(query)")
                return ""
            }
        }
        
        print("UUID[\(uuidString)]")
        return uuidString
    }
    
    public func reset() {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword       /* パスワードクラス */
        query[kSecAttrService as String] = self.service as AnyObject?    /* サービス名 */
        query[kSecAttrAccount as String] = Identifier.IDENTIFIER_KEY as AnyObject?    /* アカウント */
        
        /* 削除 */
        let result = SecItemDelete(query as CFDictionary)
        if result == noErr {
            print("[INFO][noErr] Unique Installation Identifier is successfully reset.")
        }
        else if result == errSecItemNotFound {
            print("[INFO][errSecItemNotFound] Unique Installation Identifier is successfully reset.")
        }
        else {
            print("[ERROR] Coudn't delete the Keychain Item. result = \(result) query = \(query)")
        }
    }
    
    public func update(uuidString: String) {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword       /* パスワードクラス */
        query[kSecAttrService as String] = self.service as AnyObject?    /* サービス名 */
        query[kSecAttrAccount as String] = Identifier.IDENTIFIER_KEY as AnyObject?    /* アカウント */
        query[kSecMatchLimit as String] = kSecMatchLimitOne         /* 取得する結果の最大件数を1検討する */
        query[kSecReturnAttributes as String] = kCFBooleanTrue      /* 結果を辞書で受け取る（属性値） */
        query[kSecAttrSynchronizable as String] = kCFBooleanTrue    /* iCloud同期 */
        
        var result = noErr
        /* 検索 */
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            result = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        print("status[\(status)]")
        if result == noErr {
            query = [String : AnyObject]()
            query[kSecClass as String] = kSecClassGenericPassword       /* パスワードクラス */
            query[kSecAttrService as String] = self.service as AnyObject?    /* サービス名 */
            query[kSecAttrAccount as String] = Identifier.IDENTIFIER_KEY as AnyObject?    /* アカウント */
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue    /* iCloud同期 */
            
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = uuidString as AnyObject?
            attributesToUpdate[kSecAttrCreationDate as String] = Date() as AnyObject?
            
            /* 更新 */
            result = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if result == noErr {
                print("SecItemUpdate: noErr")
            }
            else {
                print("SecItemUpdate: error(\(result))")
            }
        }
        else if result == errSecItemNotFound {
            var query = [String : AnyObject]()
            query[kSecClass as String] = kSecClassGenericPassword       /* パスワードクラス */
            query[kSecAttrService as String] = self.service as AnyObject?    /* サービス名 */
            query[kSecAttrAccount as String] = Identifier.IDENTIFIER_KEY as AnyObject?    /* アカウント */
            query[kSecAttrLabel as String] = "UUID" as AnyObject?  /* ユーザへ表示する文字列 */
            query[kSecAttrDescription as String] = "a universally unique identifier." as AnyObject? /* アイテムの説明 */
            query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock as AnyObject?  /* 再起動後最初のアンロック以降 次の再起動まで */
            query[kSecValueData as String] = uuidString as AnyObject?
            query[kSecAttrCreationDate as String] = Date() as AnyObject?
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue    /* iCloud同期 */
            
            /* 登録 */
            let result = SecItemAdd(query as CFDictionary, nil)
            if result == noErr {
                print("[ERROR] Couldn't add the Keychain Item. result = \(result) query = \(query)")
            }
        }
    }
}

/* End Of File */

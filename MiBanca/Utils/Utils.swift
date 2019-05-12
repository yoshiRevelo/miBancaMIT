//
//  Utils.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//

import Foundation
import CryptoSwift

extension String{
    func aesEncrypt(key: String, iv: String) -> String{
        let data = self.data(using: String.Encoding.utf8)
        let encrypted = try! AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](data!))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
        
    }
    
    func aesDecrypt(key: String, iv: String) -> String{
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: String.Encoding.utf8) ?? "No se pudo descifrar"
    }
    
    func encrypt() -> String{
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString()
    }
}


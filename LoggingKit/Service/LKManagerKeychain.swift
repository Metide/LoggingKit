//
//  LKKeychainManager.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 16/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import UIKit
import KeychainSwift

public class LKManagerKeychain {
    
    static let sharedInstance = LKManagerKeychain()
    
    internal let keychain:KeychainSwift = KeychainSwift(keyPrefix: "LK")
    
    func getDeviceIdentifierFromKeychain() -> String {
        
        // try to get value from keychain
        var deviceUDID:String? = self.keychain.get("keychainDeviceUDID")
        
        if deviceUDID == nil {
            deviceUDID = UIDevice.current.identifierForVendor!.uuidString
            // save new value in keychain
            self.keychain.set(deviceUDID!, forKey: "keychainDeviceUDID")
        }
        return deviceUDID!
    }
}

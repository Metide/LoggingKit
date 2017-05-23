//
//  LKModelDevice.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 16/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

import SwiftyJSON

public class LKModelDevice {
    
    internal static var instance: LKModelDevice!
    
    /// Id of the device
    dynamic private(set) var deviceId = ""
    
    /// Manufacturer of the device
    dynamic private(set) var deviceManufacturer = ""
    
    /// Model of the device
    dynamic private(set) var deviceModel = ""
    
    /// OS of the device
    dynamic private(set) var deviceOS = ""
    
    /// OS of the device
    dynamic private(set) var deviceVersionOS = ""
    
    public class func sharedInstance() -> LKModelDevice {
        self.instance = (self.instance ?? LKModelDevice())
        return self.instance
    }
    
    /// Initialization of the object
    public required init()
    {
        self.deviceManufacturer = "Apple"
        self.deviceModel = UIDevice().modelName
        self.deviceVersionOS = UIDevice.current.systemVersion
        self.deviceOS = "iOS"
        self.deviceId = LKManagerKeychain.sharedInstance.getDeviceIdentifierFromKeychain()
    }
    
    public func generateDictionary() -> Dictionary<String, String>
    {
        var dict:[String: String] = [:]
        
        dict["deviceId"] = self.deviceId
        dict["deviceManufacturer"] = self.deviceManufacturer
        dict["deviceModel"] = self.deviceModel
        dict["deviceOS"] = self.deviceOS
        
        return dict
    }
}

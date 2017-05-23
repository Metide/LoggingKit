//
//  LKModelAction.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 14/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

public class LKModelAction: NSObject, NSCoding {
    
    /// id of the error
    private(set) var idAction:TimeInterval = Date().timeIntervalSince1970
    
    /// Date of the action
    private(set) var timestamp:Date!
    
    /// Action code
    private(set) var code = ""
    
    /// Action category
    private(set) var category = ""
    
    /// Description of the action
    private(set) var desc = ""
    
    var isInSyncro:Bool = false
    
    override init()
    {
        super.init()
    }
    
    /// Initialization of the object
    ///
    /// - Parameters:
    ///   - timestamp: Date of the action
    ///   - code: Action code
    ///   - desc: Description of the action
    ///   - category: Action category
    public init(timestamp:Date = Date(), code:String, desc:String = "", category:String = "")
    {
        self.timestamp = timestamp
        self.code = code
        self.desc = desc
        self.category = category
    }
    
    // MARK: NSCoding
    
    required public init(coder decoder: NSCoder) {
        self.timestamp = decoder.decodeObject(forKey: "timestamp") as? Date ?? Date()
        self.code = decoder.decodeObject(forKey: "code") as? String ?? ""
        self.category = decoder.decodeObject(forKey: "category") as? String ?? ""
        self.desc = decoder.decodeObject(forKey: "desc") as? String ?? ""
        self.isInSyncro = decoder.decodeBool(forKey: "isInSyncro")
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.timestamp, forKey: "timestamp")
        aCoder.encode(self.code, forKey: "code")
        aCoder.encode(Int32(self.category), forKey: "category")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.isInSyncro, forKey: "isInSyncro")
    }
}

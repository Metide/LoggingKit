//
//  LKErrorModel.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 14/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

public enum LKTypeError: String {
    case Catched = "C"
    case Fatal = "F"
}

public class LKModelError: NSObject, NSCoding {
    
    /// id of the error
    private(set) var idError:TimeInterval = Date().timeIntervalSince1970
    
    /// Date of the error
    private(set) var timestamp:Date!
    
    /// Class of the error
    private(set) var objClass = ""
    
    /// Number of the error
    private(set) var line:Int64 = 0
    
    /// Type of the error
    private(set) var type:String = LKTypeError.Catched.rawValue
    
    /// Description of the error
    private(set) var desc = ""
    
    /// Category of the error
    private(set) var category = ""
    
    var isInSyncro:Bool = false
    
    override init()
    {
        super.init()
    }
    
    /// Initialization of the object
    ///
    /// - Parameters:
    ///   - timestamp: Date of the error
    ///   - type: Type of the error
    ///   - objClass: Class of the error
    ///   - line: Number of the error
    ///   - desc: Description of the error
    ///   - category: Category of the error
    public init(timestamp:Date = Date(), type:LKTypeError, objClass:String = "", line:Int64 = 0, desc:String, category:String)
    {
        self.timestamp = timestamp
        self.type = type.rawValue
        self.objClass = objClass
        self.line = line
        self.desc = desc
        self.category = category
    }
    
    // MARK: NSCoding
    required public init(coder decoder: NSCoder) {
        self.timestamp = decoder.decodeObject(forKey: "timestamp") as? Date ?? Date()
        self.type = decoder.decodeObject(forKey: "type") as? String ?? LKTypeError.Catched.rawValue
        self.objClass = decoder.decodeObject(forKey: "objClass") as? String ?? ""
        self.desc = decoder.decodeObject(forKey: "desc") as? String ?? ""
        self.category = decoder.decodeObject(forKey: "category") as? String ?? ""
        self.line = decoder.decodeInt64(forKey: "line")
        self.isInSyncro = decoder.decodeBool(forKey: "isInSyncro")
        
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.timestamp, forKey: "timestamp")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.objClass, forKey: "objClass")
        aCoder.encode(Int64(self.line), forKey: "line")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.isInSyncro, forKey: "isInSyncro")
    }
    
}

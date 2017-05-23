//
//  LKFunctions.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 15/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation
import UIKit

public func debugLog(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n")
    #endif
}


func verifyUrl(urlString: String) -> Bool {
    //Check for nil
    if let url = NSURL(string: urlString) {
        // check if your application can open the NSURL instance
        return UIApplication.shared.canOpenURL(url as URL)
    }

    return false
}

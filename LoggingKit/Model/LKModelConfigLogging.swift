//
//  LKConfigLogging.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 14/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

public class LKConfigLogging
{
    var authToken:String = ""
    
    private(set) var timeoutSync:Double = 0
    private(set) var numMaxErrors:Int = 0
    private(set) var numMaxActions:Int = 0
    private(set) var timeoutServiceRestApi:Double = 0
    private(set) var domainURL:String = ""
    
    // MARK: Variables
    /// Maximum number of Error (default is 15)
    public func setNumMaxErrors(numMaxErrors:Int)
    {
        self.numMaxErrors = numMaxErrors == 0 ? 15 : numMaxErrors
    }
    
    /// Maximum number of Action (default is 15)
    public func setNumMaxActions(numMaxActions:Int)
    {
        self.numMaxActions = numMaxActions == 0 ? 15 : numMaxActions
    }
    
    /// Maximum number of seconds for synchronization with the server (default is 15)
    public func setTimeoutSync(timeoutSync:Double)
    {
        self.timeoutSync = timeoutSync == 0 ? 15 : timeoutSync
    }
    
    /// Maximum number of seconds for timeout request/response service API Rest
    public func setTimeoutServiceRestApi(timeoutServiceRestApi:Double)
    {
        self.timeoutServiceRestApi = timeoutServiceRestApi == 0 ? 60 : timeoutServiceRestApi
    }
    
    public func setDomainURL(domainURL:String)
    {
        if domainURL.isEmpty
        {
            assertionFailure("APIManager -> domainURL is empty")
        }
        else if verifyUrl(urlString: domainURL) == false
        {
            assertionFailure("APIManager -> not verifyUrl")
        }
        
        self.domainURL = domainURL
    }
    
    
    /// Initializing method of the configuration object
    ///
    /// - Parameters:
    ///   - domainURL: Endpoint Domain for REST Services (es.http: //www.xxxx.xxxx/api)
    ///   - authToken: Authorization Token for Rest Of Service Calls
    ///   - numMaxError: Maximum number of Error (default is 15)
    ///   - numMaxAction: Maximum number of Action (default is 15)
    ///   - timeoutSync: Maximum number of seconds for synchronization with the server (default is 15)
    ///   - timeoutServiceRestApi: Maximum number of seconds for timeout request/response service API Rest (default is 60)
    public required init(domainURL:String, authToken:String="", numMaxErrors:Int = 0, numMaxActions:Int = 0, timeoutSync:Double = 0, timeoutServiceRestApi:Double = 0)
    {
        self.authToken = authToken
        
        self.setDomainURL(domainURL: domainURL)
        self.setNumMaxErrors(numMaxErrors: numMaxErrors)
        self.setNumMaxActions(numMaxActions: numMaxActions)
        self.setTimeoutSync(timeoutSync:timeoutSync)
        self.setTimeoutServiceRestApi(timeoutServiceRestApi: timeoutServiceRestApi)
    }
}


//
//  LKManagerRestApi.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 16/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

import SwiftyJSON
import Alamofire

public class LKManagerRestApi {
    
    //MARK: Constants
    private let baseURL:String = "/api/tracking"
    
    private let api_entpoint_sendErrors = "/errors"
    private let api_entpoint_sendActions = "/actions"
    private let api_entpoint_sendHwProfiles = "/hw-profiles"
    
    //MARK: Variables
    private(set) var domainURL:String = ""
    private(set) var authToken:String = ""
    private(set) var networkType:String = ""
    
    var timeoutRequest:Double = 60
    {
        didSet
        {
            timeoutRequest = timeoutRequest == 0 ? 60 : 0
        }
    }
    
    
    //MARK: Init Method
    public convenience init(domainURL:String, authToken:String, timeoutRequest:Double = 60) {
        
        self.init()
        
        self.timeoutRequest = timeoutRequest
        self.domainURL = domainURL
        self.authToken = authToken
    }
    
    //MARK:Method generete info for request
    private func generateSessionManager() -> Alamofire.SessionManager
    {
        URLCache.shared.removeAllCachedResponses()
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = self.timeoutRequest
        
        return manager
        
    }
    
    private func generateHeaders(authToken:String, complete:@escaping (HTTPHeaders)->Void)
    {
        LKManagerCoreLocation.sharedInstance.getCurrentLocation { (coordinate) in
            
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = "Bearer \(authToken)"
            
            headers["X-TPay-App-Version"] = "application/json"
            
            headers["X-TPay-Device-Id"] = LKModelDevice.sharedInstance().deviceId
            headers["X-TPay-OS-Type"] = LKModelDevice.sharedInstance().deviceOS
            headers["X-TPay-OS-Version"] = LKModelDevice.sharedInstance().deviceVersionOS
            
            if coordinate != nil
            {
                headers["X-TPay-Latitude"] = "\(String(describing: coordinate?.latitude))"
                headers["X-TPay-Longitude"] = "\(String(describing: coordinate?.longitude))"
                headers["X-TPay-GPS-Error"] = ""
            }
            
            headers["X-TPay-Connection-Type"] = ""
            headers["X-TPay-Mobile-Network-Type"] = ""
            headers["X-TPay-App-Millis"] = "\(Date().timeIntervalSince1970)"
            
            complete(headers)
        }
    }
    
    //MARK: Methods Public
    public func setAuthToken(authToken:String)
    {
        self.authToken = authToken
    }
    
    public func setNetworkType(networkType:String)
    {
        self.networkType = networkType
    }
    
    public func sendHardwareProfile(device:LKModelDevice, onSuccess:@escaping(Bool) -> Void, onFailure:@escaping(Error) -> Void){
        
        self.generateHeaders(authToken: authToken) { (headers) in
            
            let url : String = self.domainURL + self.baseURL + self.api_entpoint_sendHwProfiles
            
            let manager:Alamofire.SessionManager = self.generateSessionManager()
            
            manager.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {  response in
                    switch (response.result) {
                    case .success:
                        //do json stuff
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            //timeout here
                        }
                        print("\n\nAuth request failed with error:\n \(error)")
                        break
                    }
            }
            
        }
    }
    
    public func sendAction(action:LKModelAction, onSuccess:@escaping(Bool, LKModelAction) -> Void, onFailure:@escaping(Error) -> Void){
        
        self.generateHeaders(authToken: authToken) { (headers) in
            
            let url : String = self.domainURL + self.baseURL + self.api_entpoint_sendActions
            
            let manager:Alamofire.SessionManager = self.generateSessionManager()
            
            manager.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {  response in
                    switch (response.result) {
                    case .success:
                        //do json stuff
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            //timeout here
                        }
                        print("\n\nAuth request failed with error:\n \(error)")
                        break
                    }
                    
            }
        }
    }
    
    public func sendErrors(error:[LKModelError], onSuccess:@escaping(Bool, [LKModelError]) -> Void, onFailure:@escaping(Error) -> Void){
        
        self.generateHeaders(authToken: authToken) { (headers) in
            
            let url : String = self.domainURL + self.baseURL + self.api_entpoint_sendErrors
            
            let manager:Alamofire.SessionManager = self.generateSessionManager()
            
            manager.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {  response in
                    switch (response.result) {
                    case .success:
                        //do json stuff
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            //timeout here
                        }
                        print("\n\nAuth request failed with error:\n \(error)")
                        break
                    }
            }
        }
    }
    
    
    
}

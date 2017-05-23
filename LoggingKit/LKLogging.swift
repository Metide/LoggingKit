//
//  LKLogging.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 12/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

/// Log Manager
public class LKLogging: NSObject {
    
    // MARK: Static Variables
    internal static var instance: LKLogging?
    
    //internal let instanceCrashLibrary = KSCrash.sharedInstance()
    
    internal var timerSync:Timer?
    internal var apiManager:LKManagerRestApi?
    internal var config:LKConfigLogging?
    internal var persistanceManager:LKManagerPersistence = LKManagerPersistence()
    
    // MARK: Shared Instance
    public class func sharedInstance() -> LKLogging {
        self.instance = (self.instance ?? LKLogging())
        return self.instance!
    }
    
    
    // MARK: Init Method
    override init() {
        
        super.init()
    }
    
    
    /// Method to initialize the library
    ///
    /// - Parameter config: Configuration object
    public func initInstance(config:LKConfigLogging) {
        
        self.config = config
        
        //Init API Manager
        self.apiManager = LKManagerRestApi.init(domainURL: (self.config?.domainURL)!, authToken: (self.config?.authToken)!)
        
        if self.persistanceManager.diffSecondOfLastUpdate() >= Int((self.config?.timeoutSync)!)
        {
            self.update(isCallFunction: true)
        }
        
        //Init timer sync
        //self.timerSync = Timer.scheduledTimer(timeInterval: (self.config?.timeoutSync)!, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    /// Method for refreshing the authorization token
    ///
    /// - Parameter authToken: Access Tokens
    public func setAuthToken(authToken:String) {
        
        self.config?.authToken = authToken
        self.apiManager?.setAuthToken(authToken:authToken)
    }
    
    internal func update(isCallFunction:Bool = false) {
        
        let actions:[LKModelAction] = self.persistanceManager.getActionsForSyncro()
        let errors:[LKModelError] = self.persistanceManager.getErrorsForSyncro()
        
        if isCallFunction == false
        {
            debugLog(object: "timerSync -> isTimer -> \(Date())")
            
            self.syncroErrorsWithServer(errors: errors)
            self.syncroActionsWithServer(actions: actions)
        }
        else
        {
            if errors.count >= (self.config?.numMaxErrors)!  {
                debugLog(object: "timerSync -> update -> errors")
                self.syncroErrorsWithServer(errors: errors)
            }
            
            if actions.count >= (self.config?.numMaxActions)!  {
                debugLog(object: "timerSync -> update -> actions")
                self.syncroActionsWithServer(actions: actions)
            }
            
            self.syncroActionsWithServer(actions: actions)
        }
        
    }
    
    private func syncroErrorsWithServer(errors:[LKModelError])
    {
        if errors.count > 0
        {
            errors.forEach { (error) in
                error.isInSyncro = true
            }
            
            self.persistanceManager.saveError(errors: errors)
            
            /*
             self.apiManager?.sendErrors(error: errors, onSuccess: { (complete, errors) in
             
             }, onFailure: { (error) in
             
             })
             */
        }
    }
    
    private func syncroActionsWithServer(actions:[LKModelAction])
    {
        if actions.count > 0
        {
            actions.forEach { (action) in
                action.isInSyncro = true
            }
            
            self.persistanceManager.saveActions(actions: actions)
            
            /*
             actions.forEach({ (action) in
             
             self.apiManager?.sendAction(action: action, onSuccess: { (complete, action) in
             
             }, onFailure: { (error) in
             
             })
             
             })
             */
        }
    }
    
    // MARK: Action
    public func addError(error:LKModelError) {
        self.persistanceManager.saveError(errors: [error])
        self.update(isCallFunction: true)
    }
    
    public func addAction(action:LKModelAction) {
        self.persistanceManager.saveActions(actions: [action])
        self.update(isCallFunction: true)
    }
}

/*
extension LKLogging: CrashEyeDelegate {
    public func crashEyeDidCatchCrash(with model: CrashModel) {
        debugLog(object: model)
        
        let error:LKModelError = LKModelError.init(timestamp: Date(), type: LKTypeError.Fatal, objClass: "", line: 0, desc: model.callStack, category: "")
        self.addError(error: error)
    }
}
 */

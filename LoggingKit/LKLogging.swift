//
//  LKLogging.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 12/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation
import KSCrash

/// Log Manager
public class LKLogging: NSObject {
    
    // MARK: Static Variables
    internal static var instance: LKLogging?
    
    internal let instanceCrashLibrary = KSCrash.sharedInstance()
    
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
        
        self.installCrashHandler()
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
        debugLog(object: error)
        self.persistanceManager.saveError(errors: [error])
        self.update(isCallFunction: true)
    }
    
    public func addAction(action:LKModelAction) {
        debugLog(object: action)
        self.persistanceManager.saveActions(actions: [action])
        self.update(isCallFunction: true)
    }
}

extension LKLogging
{
    // MARK: Init KSCrash
    internal func installCrashHandler() {
        
        self.instanceCrashLibrary?.addConsoleLogToReport = true
        self.instanceCrashLibrary?.printPreviousLog = false
        self.instanceCrashLibrary?.catchZombies = true
        
        self.instanceCrashLibrary?.onCrash = { (report)  in
            
            
        }
        
        self.instanceCrashLibrary?.install()
        
        print("reportCount -> \(self.instanceCrashLibrary?.reportCount ?? 0)")
        
        self.instanceCrashLibrary?.sendAllReports(completion: { (report, isComplete, error) in
            
            /*
             report?.forEach({ (report) in
             
             //let error:LKErrorModel = LKErrorModel
             
             let reportDictionary:Dictionary<String, AnyObject> = (report as! Dictionary)
             
             if let crash:Dictionary<String, AnyObject> = reportDictionary["crash"] as? Dictionary
             {
             //let threads:Array<Dictionary<String, AnyObject>> = (crash["threads"] as? Array<Dictionary<String, AnyObject>>)!
             //print("thread -> \(threads[0]["contents"])")
             }
             
             })
             
             */
            
        })
    }
    
}

//
//  LKManagerPersistence.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 22/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation
import UIKit



class LKManagerPersistence {
    
    let keyErrors = "loggingkit.errors"
    let keyActions = "loggingkit.actions"
    let keyLastUpdate = "loggingkit."
    
    public func setLastUpdate(date:Date)
    {
        UserDefaults.standard.set(date, forKey: keyLastUpdate)
        UserDefaults.standard.synchronize()
    }
    
    public func diffSecondOfLastUpdate() -> Int
    {
        if let date = UserDefaults.standard.object(forKey: keyLastUpdate) as? Date {
            
            return date.seconds(from: Date())
        }
        
        return 0
        
    }
    
    public func deleteAllErrors()
    {
        UserDefaults.standard.removeObject(forKey: keyErrors)
    }
    
    public func deleteAllActions()
    {
        UserDefaults.standard.removeObject(forKey: keyActions)
    }
    
    public func deleteErrors(errors:[LKModelError])
    {
        var storageErrors:[LKModelError] = self.getErrorsForSyncro()
        storageErrors.append(contentsOf: self.getErrorsInSyncro())
        
        storageErrors = storageErrors.filter({ (storageError) -> Bool in
            
            return errors.filter({ (error) -> Bool in
                
                return storageError.idError != error.idError
                
            }).count > 0
            
        })
        
        let data = NSKeyedArchiver.archivedData(withRootObject: storageErrors)
        UserDefaults.standard.set(data, forKey: keyErrors)
        UserDefaults.standard.synchronize()
    }
    
    public func deleteActions(actions:[LKModelAction])
    {
        var storageActions:[LKModelAction] = self.getActionsForSyncro()
        storageActions.append(contentsOf: self.getActionsInSyncro())
        
        storageActions = actions.filter({ (storageAction) -> Bool in
            
            return actions.filter({ (action) -> Bool in
                
                return storageAction.idAction != action.idAction
                
            }).count > 0
            
        })
        
        let data = NSKeyedArchiver.archivedData(withRootObject: storageActions)
        UserDefaults.standard.set(data, forKey: keyActions)
        UserDefaults.standard.synchronize()
    }
    
    public func saveError(errors:[LKModelError])
    {
        var mergeErrors:[LKModelError] = [LKModelError]()
        mergeErrors.append(contentsOf: errors)
        
        let storageErrors:[LKModelError] = self.getErrorsForSyncro()
        
        storageErrors.forEach { (storageError) in
            
            errors.forEach({ (error) in
                
                if storageError.idError != error.idError
                {
                    mergeErrors.append(storageError)
                }
            })
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: mergeErrors)
        UserDefaults.standard.set(data, forKey: keyErrors)
        UserDefaults.standard.synchronize()
        
    }
    
    public func saveActions(actions:[LKModelAction])
    {
        var mergeActions:[LKModelAction] = [LKModelAction]()
        mergeActions.append(contentsOf: actions)
        
        let storageActions:[LKModelAction] = self.getActionsForSyncro()
        
        storageActions.forEach { (storageAction) in
            
            actions.forEach({ (action) in
                
                if storageAction.idAction != action.idAction
                {
                    mergeActions.append(storageAction)
                    return
                }
            })
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: mergeActions)
        UserDefaults.standard.set(data, forKey: keyActions)
        UserDefaults.standard.synchronize()
    }
    
    public func getActionsForSyncro() -> [LKModelAction]
    {
        if let data = UserDefaults.standard.object(forKey: keyActions) as? NSData {
            
            let actions:[LKModelAction] = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LKModelAction]
            
            return actions.filter({ (action) -> Bool in
                
                action.isInSyncro == false
                
            })
        }
        else
        {
            return [LKModelAction]()
        }
    }
    
    public func getActionsInSyncro() -> [LKModelAction]
    {
        if let data = UserDefaults.standard.object(forKey: keyActions) as? NSData {
            
            let actions:[LKModelAction] = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LKModelAction]
            
            return actions.filter({ (action) -> Bool in
                
                action.isInSyncro == true
                
            })
        }
        else
        {
            return [LKModelAction]()
        }
    }
    
    
    public func getErrorsForSyncro() -> [LKModelError]
    {
        if let data = UserDefaults.standard.object(forKey: keyErrors) as? NSData {
            
            let errors:[LKModelError] = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LKModelError]
            
            return errors.filter({ (error) -> Bool in
                
                error.isInSyncro == false
                
            })
        }
        else
        {
            return [LKModelError]()
        }
    }
    
    public func getErrorsInSyncro() -> [LKModelError]
    {
        if let data = UserDefaults.standard.object(forKey: keyErrors) as? NSData {
            
            let errors:[LKModelError] = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [LKModelError]
            
            return errors.filter({ (error) -> Bool in
                
                error.isInSyncro == true
                
            })
        }
        else
        {
            return [LKModelError]()
        }
    }
    
}

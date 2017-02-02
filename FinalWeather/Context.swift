//
//  Context.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    // MARK: Core Data Saving support
    
    func saveContext () {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Save current context and all parent of the current context
    func saveContextToPersistenceStore() {
        if self.hasChanges {
            do {
                var contextToSave: NSManagedObjectContext? = self
                
                while(contextToSave != nil) {
                    let context = contextToSave!
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                    context.saveContext()
                    
                    contextToSave = context.parent
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

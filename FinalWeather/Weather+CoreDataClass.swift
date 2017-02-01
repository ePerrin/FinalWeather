//
//  Weather+CoreDataClass.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData

@objc(Weather)
public class Weather: NSManagedObject {
    
    // MARK: Utilities
    
    class func insertNewEntityInContext(_ context: NSManagedObjectContext) -> Weather {
        return NSEntityDescription.insertNewObject(forEntityName: "Weather", into: context) as! Weather
    }
    
    // MARK: Query
    
    class func get(byId id: Int64, inContext context: NSManagedObjectContext) -> Weather? {
        let request: NSFetchRequest = Weather.fetchRequest()
        request.predicate = NSPredicate(format:"\(Weather.id) == %i", id)
        
        do {
            let entities = try context.fetch(request)
            if entities.count == 1 {
                return entities.last
            }
        } catch {
            NSLog("Error just occured to get Weather with \(Weather.id) = \(id)")
        }
        
        return nil
    }
}

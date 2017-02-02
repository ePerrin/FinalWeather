//
//  City+CoreDataClass.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {
    
    // MARK: Utilities
    
    class func insertNewEntityInContext(_ context: NSManagedObjectContext) -> City {
        return NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
    }
    
    // MARK: Query
    
    class func get(byId id: Int64, inContext context: NSManagedObjectContext) -> City? {
        let request: NSFetchRequest = City.fetchRequest()
        request.predicate = NSPredicate(format:"\(City.id) == %i", id)
        
        do {
            let entities = try context.fetch(request)
            if entities.count == 1 {
                return entities.last
            }
        } catch {
            NSLog("Error just occured to get City with \(City.id) = \(id)")
        }
        
        return nil
    }
    
    class func requestCities() -> NSFetchRequest<City> {
        let request: NSFetchRequest = City.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: City.name, ascending: true)]
        
        return request
    }
    
    class func getCities(inContext context: NSManagedObjectContext) -> [City] {
        let request: NSFetchRequest = City.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            NSLog("Error just occured to get Cities")
        }
        
        return []
    }
}

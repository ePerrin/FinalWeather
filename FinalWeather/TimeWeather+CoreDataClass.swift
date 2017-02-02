//
//  TimeWeather+CoreDataClass.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData

@objc(TimeWeather)
public class TimeWeather: NSManagedObject {

    // MARK: Utilities
    
    class func insertNewEntityInContext(_ context: NSManagedObjectContext) -> TimeWeather {
        return NSEntityDescription.insertNewObject(forEntityName: "TimeWeather", into: context) as! TimeWeather
    }
    
    // MARK: Query
    
    class func get(byDate date: NSDate, andCity city: City, inContext context: NSManagedObjectContext) -> TimeWeather? {
        let request: NSFetchRequest = TimeWeather.fetchRequest()
        request.predicate = NSPredicate(format:"\(TimeWeather.date) = %@ AND \(TimeWeather.city) = %@", date, city)
        
        do {
            let entities = try context.fetch(request)
            if entities.count == 1 {
                return entities.last
            }
        } catch {
            NSLog("Error just occured to get TimeWeather with \(TimeWeather.date) = \(date) and \(TimeWeather.city) = \(city.id)")
        }
        
        return nil
    }
    
    class func getMostCloser(forCity city: City, inContext context: NSManagedObjectContext) -> TimeWeather? {
        var dateNow = NSDate()
        
        dateNow = dateNow.addingTimeInterval(-1.5 * 3600) // 1h30 from now
        
        let request: NSFetchRequest = TimeWeather.fetchRequest()
        request.predicate = NSPredicate(format:"\(TimeWeather.date) > %@ AND \(TimeWeather.city) = %@", dateNow, city)
        request.sortDescriptors = [NSSortDescriptor(key: TimeWeather.date, ascending: true)]
        request.fetchLimit = 1
        
        do {
            let entities = try context.fetch(request)
            if entities.count == 1 {
                return entities.last
            }
        } catch {
            NSLog("Error just occured to get TimeWeather with \(TimeWeather.date) = \(date) and \(TimeWeather.city) = \(city.id)")
        }
        
        return nil
    }
    
    class func requestGetForecast(forCity city: City) -> NSFetchRequest<TimeWeather> {
        var dateNow = NSDate()
        
        dateNow = dateNow.addingTimeInterval(-1.5 * 3600) // 1h30 hours from now
        
        let request: NSFetchRequest = TimeWeather.fetchRequest()
        request.predicate = NSPredicate(format:"\(TimeWeather.date) > %@ AND \(TimeWeather.city) = %@", dateNow, city)
        request.sortDescriptors = [NSSortDescriptor(key: TimeWeather.date, ascending: true)]
        
        return request
    }
    
}

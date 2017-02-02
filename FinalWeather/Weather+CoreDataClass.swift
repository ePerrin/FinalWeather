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
    
    fileprivate var isIconLoading = false
    
    class func insertNewEntityInContext(_ context: NSManagedObjectContext) -> Weather {
        return NSEntityDescription.insertNewObject(forEntityName: "Weather", into: context) as! Weather
    }
    
    func loadIconIfNeeded() {
        guard let iconName = self.iconName, self.icon == nil && !self.isIconLoading else {
            return
        }
        
        self.isIconLoading = true
        APIManager.sharedInstance().getImage(forIconName: iconName
            , success: {
                data in
                
                guard self.isAccessibilityElement else { return }
                
                self.icon = data
                self.isIconLoading = false
                
            }, error: {
                error in
                
                guard self.isAccessibilityElement else { return }
                
                self.isIconLoading = false
                
        })
        
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

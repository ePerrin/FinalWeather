//
//  City+CoreDataProperties.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var lat: NSNumber?
    @NSManaged public var lon: NSNumber?
    @NSManaged public var timeWeathers: NSSet?

}

// MARK: Generated accessors for timeWeathers
extension City {

    @objc(addTimeWeathersObject:)
    @NSManaged public func addToTimeWeathers(_ value: TimeWeather)

    @objc(removeTimeWeathersObject:)
    @NSManaged public func removeFromTimeWeathers(_ value: TimeWeather)

    @objc(addTimeWeathers:)
    @NSManaged public func addToTimeWeathers(_ values: NSSet)

    @objc(removeTimeWeathers:)
    @NSManaged public func removeFromTimeWeathers(_ values: NSSet)

}

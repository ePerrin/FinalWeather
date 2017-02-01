//
//  Weather+CoreDataProperties.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather");
    }

    @NSManaged public var id: Int64
    @NSManaged public var main: String?
    @NSManaged public var iconName: String?
    @NSManaged public var icon: NSData?
    @NSManaged public var detail: String?
    @NSManaged public var timeWeathers: NSSet?

}

// MARK: Generated accessors for timeWeathers
extension Weather {

    @objc(addTimeWeathersObject:)
    @NSManaged public func addToTimeWeathers(_ value: TimeWeather)

    @objc(removeTimeWeathersObject:)
    @NSManaged public func removeFromTimeWeathers(_ value: TimeWeather)

    @objc(addTimeWeathers:)
    @NSManaged public func addToTimeWeathers(_ values: NSSet)

    @objc(removeTimeWeathers:)
    @NSManaged public func removeFromTimeWeathers(_ values: NSSet)

}

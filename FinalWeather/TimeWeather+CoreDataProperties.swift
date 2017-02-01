//
//  TimeWeather+CoreDataProperties.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData


extension TimeWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeWeather> {
        return NSFetchRequest<TimeWeather>(entityName: "TimeWeather");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var temp: NSNumber?
    @NSManaged public var tempMin: NSNumber?
    @NSManaged public var tempMax: NSNumber?
    @NSManaged public var cloudiness: NSNumber?
    @NSManaged public var pressure: NSNumber?
    @NSManaged public var humidity: NSNumber?
    @NSManaged public var windSpeed: NSNumber?
    @NSManaged public var windDeg: NSNumber?
    @NSManaged public var sunrise: NSDate?
    @NSManaged public var sunset: NSDate?
    @NSManaged public var city: City?
    @NSManaged public var weather: Weather?

}

//
//  TimeWeather+Mapping.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension TimeWeather {
    
    // MARK: Properties
    
    @nonobjc static let date = "date"
    @nonobjc static let temp = "temp"
    @nonobjc static let tempMin = "tempMin"
    @nonobjc static let tempMax = "tempMax"
    @nonobjc static let cloudiness = "cloudiness"
    @nonobjc static let pressure = "pressure"
    @nonobjc static let humidity = "humidity"
    @nonobjc static let windSpeed = "windSpeed"
    @nonobjc static let windDeg = "windDeg"
    @nonobjc static let sunrise = "sunrise"
    @nonobjc static let sunset = "sunset"
    @nonobjc static let city = "city"
    @nonobjc static let weather = "weather"
    
    // MARK: Deserialisation
    
    class func completeFromJSON(_ json: JSON, andCity city: City, inContext context: NSManagedObjectContext) -> TimeWeather? {
        // get date, if not exist not deserialize
        guard let dateDouble = json[API.resDt].double else {
            return nil
        }
        
        let date = Date(timeIntervalSince1970: dateDouble) as NSDate // DATEDOUBLE IS MAYBE IN MILLISECOND
        
        let entity = TimeWeather.manage(withDate: date, andCity: city, inContext: context)
        
        // temp value
        if let value = json[API.resMain][API.resTemp].number {
            entity.temp = value
        }
        
        // tempMin value
        if let value = json[API.resMain][API.resTempMin].number {
            entity.tempMin = value
        }
        
        // tempMax value
        if let value = json[API.resMain][API.resTempMax].number {
            entity.tempMax = value
        }
        
        // pressure value
        if let value = json[API.resMain][API.resPressure].number {
            entity.pressure = value
        }
        
        // humidity value
        if let value = json[API.resMain][API.resHumidity].number {
            entity.humidity = value
        }
        
        // cloudiness value
        if let value = json[API.resClouds][API.resAll].number {
            entity.cloudiness = value
        }
        
        // windSpeed value
        if let value = json[API.resWind][API.resSpeed].number {
            entity.windSpeed = value
        }
        
        // windDeg value
        if let value = json[API.resWind][API.resDeg].number {
            entity.windDeg = value
        }
        
        // sunrise value
        if let value = json[API.resSys][API.resSunrise].double {
            entity.sunrise = Date(timeIntervalSince1970: value) as NSDate
        }
        
        // sunset value
        if let value = json[API.resSys][API.resSunset].double {
            entity.sunset = Date(timeIntervalSince1970: value) as NSDate
        }
        
        return entity
    }
    
    // MARK: Support
    
    fileprivate class func manage(withDate date: NSDate, andCity city: City, inContext context: NSManagedObjectContext) -> TimeWeather {
        let entity: TimeWeather
        
        if let entityLocale = TimeWeather.get(byDate: date, andCity: city, inContext: context) {
            entity = entityLocale
        } else {
            entity = TimeWeather.insertNewEntityInContext(context)
            entity.date = date
            entity.city = city
        }
        
        return entity
    }
}

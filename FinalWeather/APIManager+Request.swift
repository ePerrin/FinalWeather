//
//  APIManager+Request.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension APIManager {
    func getCurrentWeather(forCityName name: String, inContext context: NSManagedObjectContext, success: @escaping (City)->(), error: @escaping (NSError?) -> ()) {
        
        _ = self.GET("\(API.pathCurrent)", parameters: [API.parameterCityName: name]
            , success: { session, result in
                guard let resultJson = result, let city = City.completeFromJSON(resultJson, inContext: context) else {
                    error(nil)
                    return
                }
                
                let timeWeather = TimeWeather.completeFromJSON(resultJson, andCity: city, inContext: context)
                
                if let weatherJson = resultJson[API.resWeather].array?.first, let weather = Weather.completeFromJSON(weatherJson, inContext: context) {
                    timeWeather?.weather = weather
                }
                
                context.saveContextToPersistenceStore()
                
                success(city)
                
            }, failure: { session, errorP in
                error(errorP)
        })
    }
    
    func getForecastWeather(forCityName name: String, inContext context: NSManagedObjectContext, success: @escaping ()->(), error: @escaping (NSError?) -> ()) {
        
        _ = self.GET("\(API.pathForecast)", parameters: [API.parameterCityName: name]
            , success: { session, result in
                guard let resultJson = result, let listJson = resultJson[API.resList].array, let city = City.completeFromJSON(resultJson[API.resCity], inContext: context), listJson.count > 0 else {
                    error(nil)
                    return
                }
                
                for itemJson in listJson {
                    let timeWeather = TimeWeather.completeFromJSON(itemJson, andCity: city, inContext: context)
                    
                    if let weatherJson = itemJson[API.resWeather].array?.first, let weather = Weather.completeFromJSON(weatherJson, inContext: context) {
                        timeWeather?.weather = weather
                    }
                }
                
                context.saveContextToPersistenceStore()
                
                success()
                
        }, failure: { session, errorP in
            error(errorP)
        })
    }
}

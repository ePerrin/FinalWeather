//
//  APIManager.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AFNetworking

// MARK: -

struct API {
    static let key = "d66fe97e862eb08a0a452cb25055c455"
    static let url = "http://api.openweathermap.org/data/2.5"
    
    static let pathCurrent = "weather"
    static let pathForecast = "forecast"
    static let pathDaily = "daily"
    
    static let parameterKey = "APPID"
    static let parameterCityName = "q"
    
    static let resCity = "city"
    static let resId = "id"
    static let resName = "name"
    static let resSys = "sys"
    static let resCountry = "country"
    static let resCoord = "coord"
    static let resLon = "lon"
    static let resLat = "lat"
    static let resMain = "main"
    static let resDescription = "description"
    static let resIcon = "icon"
    static let resDt = "dt"
    static let resTemp = "temp"
    static let resTempMin = "temp_min"
    static let resTempMax = "temp_max"
    static let resPressure = "pressure"
    static let resHumidity = "humidity"
    static let resClouds = "clouds"
    static let resAll = "all"
    static let resWind = "wind"
    static let resSpeed = "speed"
    static let resDeg = "deg"
    static let resSunrise = "sunrise"
    static let resSunset = "sunset"
    static let resWeather = "weather"
    static let resList = "list"
}

// MARK : -

class APIManager: NSObject {
    fileprivate static let singleton = APIManager()
    
    fileprivate var manager: AFHTTPSessionManager
    fileprivate var requestsOngoing = 0
    
    // MARK: Initialization
    
    fileprivate override init() {
        
        let manager = AFHTTPSessionManager(baseURL: URL(string: API.url))
        
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        self.manager = manager
    }
    
    class func sharedInstance() -> APIManager {
        return self.singleton
    }
    
    // MARK: Http verbs
    
    func GET(_ URLString: String, parameters: [String: Any]?, success: (@escaping (URLSessionDataTask, JSON?) -> Void), failure: (@escaping (URLSessionDataTask?, NSError) -> Void)) -> URLSessionDataTask? {
        // Prepare request
        let manager = self.manager
        var parametersFinal: [String: Any] = [:]
        
        if let parameters = parameters {
            parametersFinal = parameters
        }
        
        parametersFinal[API.parameterKey] = API.key
        
        // Request will be launched
        self.willRequestLaunched()
        
        // Launch Request
        return manager.get(URLString, parameters: parametersFinal, progress: nil, success: self.manageSuccess(success), failure: self.manageFailure(failure))
    }
    
    // MARK: Support
    
    fileprivate func manageSuccess(_ bloc: (@escaping (URLSessionDataTask, JSON?) -> Void)) -> ((URLSessionDataTask, Any?) -> Void)? {
        return {
            session, result in
            
            var json: JSON?
            
            if let result = result as? Data {
                json = JSON(data: result)
            } else if let result = result {
                json = JSON(result)
            }
            
            bloc(session, json)
            self.didRequestComplete()
        }
    }
    
    fileprivate func manageFailure(_ bloc: (@escaping (URLSessionDataTask?, NSError) -> Void)) -> ((URLSessionDataTask?, Error) -> Void)? {
        return {
            session, error in
            
            let error = error as NSError
            
            NSLog("errror code : \(error.code) ; \(error.localizedDescription) \(error.localizedFailureReason)")
            
            bloc(session, error as NSError)
            self.didRequestComplete()
        }
    }
    
    fileprivate func willRequestLaunched() {
        self.manageRequestCount(true)
    }
    
    fileprivate func didRequestComplete() {
        self.manageRequestCount(false)
    }
    
    fileprivate func manageRequestCount(_ isAdd: Bool) {
        if isAdd {
            self.requestsOngoing += 1
        } else {
            self.requestsOngoing -= 1
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = self.requestsOngoing > 0
    }
}

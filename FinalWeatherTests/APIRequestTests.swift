//
//  APIRequestTests.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import XCTest
import CoreData
@testable import FinalWeather

class APIRequestTests: XCTestCase {
    
    // MARK: Attributes - Utilities
    
    let cityName = "Lyon,fr"
    let expectationTimeout: TimeInterval = 10 // Less than APIUtilities timeout, because test are made with a strong internet connexion (not in 3G)
    
    // MARK: Attributes - managedObjectContext
    
    fileprivate static var storeCoordinator: NSPersistentStoreCoordinator!
    fileprivate static var managedObjectModel: NSManagedObjectModel!
    fileprivate static var store: NSPersistentStore!
    fileprivate static var managedObjectContext: NSManagedObjectContext!
    
    // MARK: Environment
    
    override class func setUp() {
        super.setUp()
        
        // Context
        self.managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        self.store = try? storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator
    }
    
    override class func tearDown() {
        self.managedObjectContext = nil
        
        XCTAssertThrows(DBError.cannotBeEmpty(message: "couldn't remove persistant store ")) { try self.storeCoordinator.remove(self.store) }
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    func test1GetCurrentWeather() {
        // Given
        let context = APIRequestTests.managedObjectContext!
        let expectation = self.expectation(description: "Testing Http request get current weather")
        
        // When
        APIManager.sharedInstance().getCurrentWeather(forCityName: self.cityName, inContext: context
            , success: {
                
                // city tests
                let cities = self.getCities(inContext: context)
                let city = cities.first
                
                XCTAssertTrue(cities.count == 1, "cities count are not equal to one : \(cities.count)")
                XCTAssertNotNil(city?.name, "name should be not nil")
                XCTAssertNotNil(city?.country, "country should be not nil")
                XCTAssertTrue(city?.lat != 0, "lat should be != 0")
                XCTAssertTrue(city?.lon != 0, "lon should be != 0")
                
                // timeWeather Tests
                let timeWeathers = self.getTimeWeathers(forCity: city, inContext: context)
                let timeWeather = timeWeathers.first
                
                XCTAssertTrue(timeWeathers.count == 1, "timeWeathers count are not equal to one : \(timeWeathers.count)")
                XCTAssertNotNil(timeWeather?.date, "date should be not nil")
                XCTAssertNotNil(timeWeather?.temp, "temp should be not nil")
                XCTAssertNotNil(timeWeather?.tempMin, "tempMin should be not nil")
                XCTAssertNotNil(timeWeather?.tempMax, "tempMax should be not nil")
                XCTAssertNotNil(timeWeather?.cloudiness, "cloudiness should be not nil")
                XCTAssertNotNil(timeWeather?.pressure, "pressure should be not nil")
                XCTAssertNotNil(timeWeather?.humidity, "humidity should be not nil")
                XCTAssertNotNil(timeWeather?.windSpeed, "windSpeed should be not nil")
                XCTAssertNotNil(timeWeather?.windDeg, "windDeg should be not nil")
                XCTAssertNotNil(timeWeather?.sunrise, "sunrise should be not nil")
                XCTAssertNotNil(timeWeather?.sunset, "sunset should be not nil")
                
                // weather tests
                let weathers = self.getWeathers(inContext: context)
                let weather = weathers.first
                
                XCTAssertTrue(weathers.count == 1, "weathers count are not equal to one : \(weathers.count)")
                XCTAssertNotNil(weather?.main, "main should be not nil")
                XCTAssertNotNil(weather?.detail, "detail should be not nil")
                XCTAssertNotNil(weather?.iconName, "iconName should be not nil")
                
                expectation.fulfill()
            }, error: {
                error in
                
                XCTFail("error block should not be called : \(error)")
                expectation.fulfill()
        })
        
        // Then
        self.waitForExpectations(timeout: self.expectationTimeout, handler: nil)
    }
    
    func test2GetForecastWeather() {
        // Given
        let context = APIRequestTests.managedObjectContext!
        let expectation = self.expectation(description: "Testing Http request get forecast 5 weather")
        
        // When
        APIManager.sharedInstance().getForecastWeather(forCityName: self.cityName, inContext: context
            , success: {
                
                // city tests
                let cities = self.getCities(inContext: context)
                let city = cities.first
                
                XCTAssertTrue(cities.count == 1, "cities count are not equal to one : \(cities.count)")
                XCTAssertNotNil(city?.name, "name should be not nil")
                XCTAssertNotNil(city?.country, "country should be not nil")
                XCTAssertTrue(city?.lat != 0, "lat should be != 0")
                XCTAssertTrue(city?.lon != 0, "lon should be != 0")
                
                // timeWeather Tests
                let timeWeathers = self.getTimeWeathers(forCity: city, inContext: context)
                
                XCTAssertTrue(timeWeathers.count > 1, "timeWeathers count are greater than one : \(timeWeathers.count)")
                for timeWeather in timeWeathers {
                    XCTAssertNotNil(timeWeather.date, "date should be not nil")
                    XCTAssertNotNil(timeWeather.temp, "temp should be not nil")
                    XCTAssertNotNil(timeWeather.tempMin, "tempMin should be not nil")
                    XCTAssertNotNil(timeWeather.tempMax, "tempMax should be not nil")
                    XCTAssertNotNil(timeWeather.cloudiness, "cloudiness should be not nil")
                    XCTAssertNotNil(timeWeather.pressure, "pressure should be not nil")
                    XCTAssertNotNil(timeWeather.humidity, "humidity should be not nil")
                    XCTAssertNotNil(timeWeather.windSpeed, "windSpeed should be not nil")
                    XCTAssertNotNil(timeWeather.windDeg, "windDeg should be not nil")
                }
                
                // weather tests
                let weathers = self.getWeathers(inContext: context)
                
                XCTAssertTrue(timeWeathers.count >= 1, "weathers count are greater or equalt than one : \(timeWeathers.count)")
                for weather in weathers {
                    XCTAssertNotNil(weather.main, "main should be not nil")
                    XCTAssertNotNil(weather.detail, "detail should be not nil")
                    XCTAssertNotNil(weather.iconName, "iconName should be not nil")
                }
                
                expectation.fulfill()
        }, error: {
            error in
            
            XCTFail("error block should not be called : \(error)")
            expectation.fulfill()
        })
        
        // Then
        self.waitForExpectations(timeout: self.expectationTimeout, handler: nil)
    }
    
    // MARK: Support
    
    func getCities(inContext context: NSManagedObjectContext) -> [City] {
        let request: NSFetchRequest = City.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            XCTFail("Error just occured to get Cities")
        }
        
        return []
    }
    
    func getTimeWeathers(forCity city: City?, inContext context: NSManagedObjectContext) -> [TimeWeather] {
        guard let city = city else { return [] }
        
        let request: NSFetchRequest = TimeWeather.fetchRequest()
        request.predicate = NSPredicate(format:"\(TimeWeather.city) = %@", city)
        
        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            XCTFail("Error just occured to get TimeWeather for city : \(city)")
        }
        
        return []
    }
    
    func getWeathers(inContext context: NSManagedObjectContext) -> [Weather] {
        let request: NSFetchRequest = Weather.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities
        } catch {
            XCTFail("Error just occured to get Weather")
        }
        
        return []
    }
}

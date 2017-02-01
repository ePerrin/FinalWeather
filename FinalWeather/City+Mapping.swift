//
//  City+Mapping.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension City {
    
    // MARK: Properties
    
    @nonobjc static let id = "id"
    @nonobjc static let name = "name"
    @nonobjc static let country = "country"
    @nonobjc static let lat = "lat"
    @nonobjc static let lon = "lon"
    
    // MARK: Deserialisation
    
    class func completeFromJSON(_ json: JSON, inContext context: NSManagedObjectContext) -> City? {
        // get id, if not exist not deserialize
        guard let id = json[API.resId].int64 else {
            return nil
        }
        
        let entity = City.manage(withId: id, inContext: context)
        
        // name value
        if let value = json[API.resName].string {
            entity.name = value
        }
        
        // country value
        if let value = json[API.resSys][API.resCountry].string {
            entity.country = value
        } else if let value = json[API.resCountry].string {
            entity.country = value
        }
        
        // lon value
        if let value = json[API.resCoord][API.resLon].number {
            entity.lon = value
        }
        
        // lat value
        if let value = json[API.resCoord][API.resLat].number {
            entity.lat = value
        }
        
        return entity
    }
    
    // MARK: Support
    
    fileprivate class func manage(withId id: Int64, inContext context: NSManagedObjectContext) -> City {
        let entity: City
        
        if let entityLocale = City.get(byId: id, inContext: context) {
            entity = entityLocale
        } else {
            entity = City.insertNewEntityInContext(context)
            entity.id = id
        }
        
        return entity
    }
}

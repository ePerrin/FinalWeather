//
//  Weather+Mapping.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Weather {
    
    // MARK: Properties
    
    @nonobjc static let id = "id"
    @nonobjc static let main = "main"
    @nonobjc static let iconName = "iconName"
    @nonobjc static let icon = "icon"
    @nonobjc static let detail = "detail"
    
    // MARK: Deserialisation
    
    class func completeFromJSON(_ json: JSON, inContext context: NSManagedObjectContext) -> Weather? {
        // get id, if not exist not deserialize
        guard let id = json[API.resId].int64 else {
            return nil
        }
        
        let entity = Weather.manage(withId: id, inContext: context)
        
        // main value
        if let value = json[API.resMain].string {
            entity.main = value
        }
        
        // detail value
        if let value = json[API.resDescription].string {
            entity.detail = value
        }
        
        // iconName value
        if let value = json[API.resIcon].string {
            entity.loadIconIfNeeded()
            entity.iconName = value
        }
        
        return entity
    }
    
    // MARK: Support
    
    fileprivate class func manage(withId id: Int64, inContext context: NSManagedObjectContext) -> Weather {
        let entity: Weather
        
        if let entityLocale = Weather.get(byId: id, inContext: context) {
            entity = entityLocale
        } else {
            entity = Weather.insertNewEntityInContext(context)
            entity.id = id
        }
        
        return entity
    }
}

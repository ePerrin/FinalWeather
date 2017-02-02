//
//  Localizable.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import Foundation

// MARK: -

enum Localizable: String {
    
    case NoDataTimeWeatherTVC = "NoDataTimeWeatherTVC"
    
    // MARK: Method to access localizable string
    
    func value() -> String {
        return value(nil)
    }
    
    func value(_ arg: String?) -> String {
        if let arg1 = arg {
            return String(format: NSLocalizedString(self.rawValue, comment: ""), arg1)
        }
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// MARK: - Date Formatter

extension DateFormatter {
    class func completeFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }
    
    class func justDateFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }
    
    class func justHourFormat() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }
}

//
//  Image.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 02/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit

// MARk: -

enum Image: String {
    case WeatherDefaultImage = "image"
    
    func value() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
}

// MARK: -

extension Weather {
    var iconUI: UIImage? {
        self.loadIconIfNeeded()
        
        if let imageData = self.icon {
            return UIImage(data: imageData as Data)
        } else {
            return Image.WeatherDefaultImage.value()
        }
    }
}

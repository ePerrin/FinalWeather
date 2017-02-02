//
//  CitiesTableViewController.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData

// IMPORTANT: If I have time, I will transform this controller inton a UITableViewController and let user the possibility to add other cities than Lyon in the app
class CitiesTableViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    
    fileprivate let segueSplitVC = "SplitVC"
    
    
    // MARK: UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cities = City.getCities(inContext: self.context)
        
        // if a city exist and a timeWeather, perform segue
        if let city = cities.first, let timeWeather = TimeWeather.getMostCloser(forCity: city, inContext: self.context) {
            self.performSegue(withIdentifier: self.segueSplitVC, sender: [city, timeWeather])
            return
        }
        
        // get data otherwise
        self.loadData()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let splitVC = segue.destination as? UISplitViewController, segue.identifier == self.segueSplitVC {
            let context = self.context
            let sender = sender as! [Any]
            let city = sender.first as! City
            let timeWeather = sender[1] as! TimeWeather
            
            let dataProvider = ForecastDataProvider()
            dataProvider.context = context
            dataProvider.city = city
            
            let leftNavController = splitVC.viewControllers.first as! UINavigationController
            let forecastTVC = leftNavController.topViewController as! ForecastTableViewController
            forecastTVC.context = context
            forecastTVC.city = city
            forecastTVC.forecastDataProvider = dataProvider
            
            let rightNavController = splitVC.viewControllers.last as! UINavigationController
            let timeWeatherTVC = rightNavController.topViewController as! TimeWeatherTableViewController
            timeWeatherTVC.context = context
            timeWeatherTVC.timeWeather = timeWeather
            
            forecastTVC.delegate = timeWeatherTVC
        }
    }
    
    // MARK: Support
    
    fileprivate func loadData() {
        let lyon = "lyon,fr"
        APIManager.sharedInstance().getCurrentWeather(forCityName: lyon, inContext: self.context
            , success: {
                city in
                
                if let timeWeathers = city.timeWeathers as? Set<TimeWeather>, let timeWeather = timeWeathers.first {
                    self.performSegue(withIdentifier: self.segueSplitVC, sender: [city, timeWeather])
                }
                
            }, error: {
                error in
                
                
            }
        )
    }
}

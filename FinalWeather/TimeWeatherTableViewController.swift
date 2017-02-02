//
//  TimeWeatherTableViewController.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData

class TimeWeatherTableViewController: UITableViewController {
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherMainLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    var context: NSManagedObjectContext!
    var timeWeather: TimeWeather!
    
    // MARK: UIViewController
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display back buton item to access menu
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(TimeWeatherTableViewController.contextDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: self.context)
        
        // refreshUI
        self.refreshUI()
    }
    
    // MARK: Notification
    
    @objc func contextDidChange(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo, let entitiesUpdated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        
        for entity in entitiesUpdated {
            if let timeWeather = entity as? TimeWeather, timeWeather == self.timeWeather {
                self.refreshUI()
                break
            }
            if let weather = entity as? Weather, weather == self.timeWeather.weather {
                self.refreshUI()
                break
            }
        }
    }
    
    // MARK: Support
    
    fileprivate func refreshUI() {
        let noData = Localizable.NoDataTimeWeatherTVC.value()
        
        self.title = self.timeWeather.city?.name
        
        self.weatherIconImageView.image = self.timeWeather.weather?.iconUI
        self.weatherMainLabel.text = self.timeWeather.weather?.main ?? noData
        self.tempLabel.text = self.timeWeather.temp != nil ? "\(self.timeWeather.temp!) °C" : noData
        self.dateLabel.text = self.timeWeather.date != nil ? "\(DateFormatter.completeFormat().string(from: self.timeWeather.date as! Date))" : ""
        
        self.pressureLabel.text = self.timeWeather.pressure != nil ? "\(self.timeWeather.pressure!) hpa" : noData
        self.humidityLabel.text = self.timeWeather.humidity != nil ? "\(self.timeWeather.humidity!) %" : noData
        self.windLabel.text = self.timeWeather.windSpeed != nil ? "\(self.timeWeather.windSpeed!) m/s" : noData
        self.cloudinessLabel.text = self.timeWeather.cloudiness != nil ? "\(self.timeWeather.cloudiness!) %" : noData
        
        self.sunriseLabel.text = self.timeWeather.sunrise != nil ? DateFormatter.justHourFormat().string(from: self.timeWeather.sunrise as! Date) : noData
        self.sunsetLabel.text = self.timeWeather.sunset != nil ? DateFormatter.justHourFormat().string(from: self.timeWeather.sunset as! Date) : noData
    }
}

extension TimeWeatherTableViewController: TimeWeatherSelectionDelegate {
    func didSelect(timeWeather: TimeWeather) {
        self.timeWeather = timeWeather
        self.refreshUI()
    }
}

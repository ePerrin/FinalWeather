//
//  ForecastTableViewController.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData

// MARK: -

protocol TimeWeatherSelectionDelegate: class {
    func didSelect(timeWeather: TimeWeather)
}

// MARK: -

class ForecastTableViewController: UITableViewController {
    var city: City!
    var context: NSManagedObjectContext!
    var forecastDataProvider: ForecastDataProviderProtocol!
    
    weak var delegate: TimeWeatherSelectionDelegate?
    
    
    // MARK: UIViewController
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // finish to implement dataProvider
        self.tableView.dataSource = self.forecastDataProvider
        self.forecastDataProvider.tableView = self.tableView
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(ForecastTableViewController.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // load data
        self.loadData()
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeWeather = self.forecastDataProvider.timeWeather(at: indexPath)
        
        self.delegate?.didSelect(timeWeather: timeWeather)
        
        if let detailViewController = self.delegate as? TimeWeatherTableViewController {
            self.splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
    }
    
    // MARK: Notification
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        self.loadData()
    }
    
    // MARK: Support
    
    fileprivate func loadData() {
        guard let cityName = self.city.name else { return }
        
        APIManager.sharedInstance().getForecastWeather(forCityName: cityName, inContext: self.context
            , success: {
                // No need to do action, NSFetchedResultsController will manage data
                
            }, error: {
                error in
                
                
            }
        )
    }
}

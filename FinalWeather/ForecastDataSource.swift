//
//  ForecastDataSource.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData

// MARK: - CitizenHistoryDataProviderProtocol

@objc protocol ForecastDataProviderProtocol: class, UITableViewDataSource {
    var city: City! { get set }
    var context: NSManagedObjectContext! { get set }
    
    weak var tableView: UITableView! { get set }
    
    func timeWeather(at indexPath: IndexPath) -> TimeWeather
}

// MARK: - CitizenHistoryDataProvider main methods

class ForecastDataProvider: NSObject, ForecastDataProviderProtocol {
    var city: City!
    var context: NSManagedObjectContext!
    
    weak var tableView: UITableView!
    
    fileprivate let timeWeatherCellIdentifier = "timeWeatherCell"
    fileprivate var _timeWeatherResultsController: NSFetchedResultsController<TimeWeather>? = nil
    
    func timeWeather(at indexPath: IndexPath) -> TimeWeather {
        return self.timeWeatherResultsController.object(at: indexPath)
    }
    
    fileprivate func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let timeWeather = self.timeWeatherResultsController.object(at: indexPath)
        
        guard let date = timeWeather.date as? Date else { return }
        
        cell.textLabel?.text = DateFormatter.justDateFormat().string(from: date)
        cell.detailTextLabel?.text = DateFormatter.justHourFormat().string(from: date)
    }
}

// MARK: - UITableViewDataSource

extension ForecastDataProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = self.timeWeatherResultsController.fetchedObjects else {
            return 0
        }
        
        return fetchedObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.timeWeatherCellIdentifier, for: indexPath)
        
        self.configure(cell: cell, at: indexPath)
        
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ForecastDataProvider: NSFetchedResultsControllerDelegate {
    var timeWeatherResultsController: NSFetchedResultsController<TimeWeather> {
        if self._timeWeatherResultsController != nil {
            return self._timeWeatherResultsController!
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: TimeWeather.requestGetForecast(forCity: self.city!), managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
        self._timeWeatherResultsController = fetchedResultsController
        
        return fetchedResultsController
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // Manage table view operations
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let newIndexPath = newIndexPath, let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

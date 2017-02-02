//
//  CitiesDataSource.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 02/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData

// MARK: - CitiesDataProviderProtocol

@objc protocol CitiesDataProviderProtocol: class, UITableViewDataSource {
    var context: NSManagedObjectContext! { get set }
    
    weak var tableView: UITableView! { get set }
    
    func city(at indexPath: IndexPath) -> City
}

// MARK: - CitiesDataProvider main methods

class CitiesDataProvider: NSObject, CitiesDataProviderProtocol {
    var city: City!
    var context: NSManagedObjectContext!
    
    weak var tableView: UITableView!
    
    fileprivate let cityCellIdentifier = "cityCell"
    fileprivate var _citiesResultsController: NSFetchedResultsController<City>? = nil
    
    func city(at indexPath: IndexPath) -> City {
        return self.citiesResultsController.object(at: indexPath)
    }
    
    fileprivate func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let city = self.citiesResultsController.object(at: indexPath)
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
    }
}

// MARK: - UITableViewDataSource

extension CitiesDataProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = self.citiesResultsController.fetchedObjects else {
            return 0
        }
        
        return fetchedObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cityCellIdentifier, for: indexPath)
        
        self.configure(cell: cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let city = self.city(at: indexPath)
        
        self.context.delete(city)
        self.context.saveContextToPersistenceStore()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension CitiesDataProvider: NSFetchedResultsControllerDelegate {
    var citiesResultsController: NSFetchedResultsController<City> {
        if self._citiesResultsController != nil {
            return self._citiesResultsController!
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: City.requestCities(), managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
        self._citiesResultsController = fetchedResultsController
        
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
                self.tableView.insertRows(at: [newIndexPath], with: .top)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .top)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let newIndexPath = newIndexPath, let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .top)
                self.tableView.insertRows(at: [newIndexPath], with: .top)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

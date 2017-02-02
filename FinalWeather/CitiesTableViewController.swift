//
//  CitiesTableViewController.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking

class CitiesTableViewController: UITableViewController {
    
    var citiesDataProviderProtocol: CitiesDataProviderProtocol!
    var context: NSManagedObjectContext!
    
    fileprivate let segueSplitVC = "SplitVC"
    
    fileprivate weak var phoneAlertTextField: UITextField?
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // finish to implement dataProvider
        self.tableView.dataSource = self.citiesDataProviderProtocol
        self.citiesDataProviderProtocol.tableView = self.tableView
        
        // add Lyon if no city
        let cities = City.getCities(inContext: self.context)
        if cities.count == 0 {
            self.addCity(withName: "lyon,fr")
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.citiesDataProviderProtocol.city(at: indexPath)
        
        guard let timeWeather = TimeWeather.getMostCloser(forCity: city, inContext: self.context) else {
            return
        }
        
        self.performSegue(withIdentifier: self.segueSplitVC, sender: [city, timeWeather])
    }
    
    // MARK: Action
    
    @IBAction func tapOnAddCityBarButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Localizable.AddCityAlertCitiesTVC.value(), message: nil, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: Localizable.TextCancel.value(),
                style: .cancel,
                handler: {
                    action in
                    
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: Localizable.TextOk.value(),
                style: .default,
                handler: {
                    action in
                    
                    guard let text = self.phoneAlertTextField?.text else {
                        return
                    }
                    
                    self.addCity(withName: text)
                }
            )
        )
        alert.addTextField {
            textField in
            
            textField.keyboardType = .default
            textField.becomeFirstResponder()
            
            self.phoneAlertTextField = textField
        }
        
        self.present(alert, animated: true, completion: nil)
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
    
    fileprivate func addCity(withName name: String) {
        APIManager.sharedInstance().getCurrentWeather(forCityName: name, inContext: self.context
            , success: {
                city in
                
                
            }, error: {
                error in
                
                if let responseError = error?.userInfo[AFNetworkingOperationFailingURLResponseErrorKey], let statusCode = (responseError as AnyObject).statusCode { // AFNetworkingOperationFailingURLResponseErrorKey SHOULD NOT BE MANGED HERE IN CONTROLLER, BUT IN APIMANAGER
                    if statusCode == 404 || statusCode == 502 { // API retrun 502 some times when city is not found
                        let alert = UIAlertController(title: Localizable.NotFoundAlertCitiesTVC.value(), message: nil, preferredStyle: .alert)
                        
                        alert.addAction(
                            UIAlertAction(
                                title: Localizable.TextOk.value(),
                                style: .cancel,
                                handler:nil
                            )
                        )
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        )
        APIManager.sharedInstance().getForecastWeather(forCityName: name, inContext: self.context
            , success: {
                
            }, error: {
                error in
        })
    }
}

//
//  AppDelegate.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import UIKit
import CoreData

// MARK: -

struct Project {
    static let name = "FinalWeather"
    static let access = "momd"
    static let bdd = Project.name + ".sqlite"
    static let storyboad = "Main"
    
    static let UserDefaultsDeviceTokenKey = "deviceToken"
    static let UserDefaultsGroupFriendsNotFirstTime = "groupFriendsNotFirstTime"
    static let UserDefaultsAppNotFirstTime = "appNotFirstTime"
}

// MARK: -

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.mainManagedObjectContext.saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var persistentStoreCoordinatorUrl: URL = self.applicationDocumentsDirectory.appendingPathComponent(Project.bdd)
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appshope.BEvent" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    fileprivate var _managedObjectModel: NSManagedObjectModel?
    var managedObjectModel: NSManagedObjectModel {
        if let _managedObjectModel = self._managedObjectModel {
            return _managedObjectModel
        }
        
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: Project.name, withExtension: Project.access)!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        self._managedObjectModel = model
        
        return model
    }
    
    fileprivate var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        if let _persistentStoreCoordinator = self._persistentStoreCoordinator {
            return _persistentStoreCoordinator
        }
        
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.persistentStoreCoordinatorUrl
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        self._persistentStoreCoordinator = coordinator
        
        return coordinator
    }
    
    fileprivate var _mainManagedObjectContext: NSManagedObjectContext?
    var mainManagedObjectContext: NSManagedObjectContext {
        if let _mainManagedObjectContext = self._mainManagedObjectContext {
            return _mainManagedObjectContext
        }
        
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        
        // Our primary MOC is a private queue concurrency type
        let persistentStoreManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistentStoreManagedObjectContext.persistentStoreCoordinator = coordinator
        persistentStoreManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        // Create an MOC for use on the main queue
        let mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.parent = persistentStoreManagedObjectContext
        mainManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        self._mainManagedObjectContext = mainManagedObjectContext
        
        return mainManagedObjectContext
    }

}


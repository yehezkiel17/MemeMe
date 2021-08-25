//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 16/4/18.
//  Copyright © 2018 Yehezkiel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var memes = [Meme]()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		return true
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate.
		// See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    let container = NSPersistentContainer(name: "MemeMe")
	    container.loadPersistentStores(completionHandler: { (_, error) in
	        if let error = error as NSError? {
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}

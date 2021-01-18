//
//  AppDelegate.swift
//  Nice Dice
//
//  Created by Roy Dawson on 1/2/18.
//  Copyright © 2018 Roy Dawson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let rootViewController = window?.rootViewController as? ContainerViewController {
            rootViewController.history = history
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    // MARK: - Core Data stack

    lazy var history: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "History")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = history.viewContext
        do {
            let fetchRequest = NSFetchRequest<RollGroup>(entityName: "RollGroup")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let historyResults = NSFetchedResultsController<RollGroup>(
                fetchRequest: fetchRequest,
                managedObjectContext: history.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            try historyResults.performFetch()
            while let sections = historyResults.sections,
                  sections.count > 0,
                  sections[0].numberOfObjects > 100 {

                let rollGroup = historyResults.object(at: IndexPath(row: 100, section: 0))
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RollGroup")
                fetchRequest.predicate = NSPredicate(format: "date <= %@", argumentArray: [rollGroup.date!])
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
                try historyResults.performFetch()
            }

            if context.hasChanges {
                try context.save()
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}


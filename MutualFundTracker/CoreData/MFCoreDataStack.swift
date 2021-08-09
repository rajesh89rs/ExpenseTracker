//
//  MFCoreDataStack.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 11/03/21.
//

import UIKit
import CoreData

class MFCoreDataStack: NSObject {

    static let shared = MFCoreDataStack()

    var persistentContainer: NSPersistentContainer {
        return lazyPersistentContainer
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var lazyPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MFCoreData")
        
        var coordinator: NSPersistentStoreCoordinator? = container.persistentStoreCoordinator
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        var newStoreUrl: URL?
        var targetUrl: URL?
        var needMigrate = false
        var needDeleteOld = false
        
        let oldStoreUrl = self.applicationDocumentsDirectory.appendingPathComponent("Application Support/MFCoreData.sqlite")
        if let directory: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mf.coredata") as NSURL?, let url = directory.appendingPathComponent("MFCoreData.sqlite") {
            newStoreUrl = url
        }
        
        if FileManager.default.fileExists(atPath: oldStoreUrl.path) {
            needMigrate = true
            targetUrl = oldStoreUrl
        }
        if let url = newStoreUrl, FileManager.default.fileExists(atPath: url.path) {
            needMigrate = false
            targetUrl = url
            
            if FileManager.default.fileExists(atPath: oldStoreUrl.path) {
                needDeleteOld = true
            }
        }
        if targetUrl == nil {
            targetUrl = newStoreUrl
        }
        
        if needMigrate, let newUrl = newStoreUrl, let target = targetUrl {
            if let store = coordinator?.persistentStore(for: target) {
                do {
                    try coordinator?.migratePersistentStore(store, to: newUrl, options: options, withType: NSSQLiteStoreType)
                    
                } catch let error {
                    print("migrate failed with error : \(error)")
                }
            }
        } else {
            do {
                try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: targetUrl, options: options)
            } catch var error as NSError {
                coordinator = nil
                NSLog("Unresolved error \(error), \(error.userInfo)")
                abort()
            } catch {
                print("Core data error: ", error)
            }
        }
        
        if needDeleteOld {
            do {
                try FileManager.default.removeItem(at: oldStoreUrl)
            } catch {
                print("Core data cannot delete old coordinator: ", error)
            }
        }

        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named 'Bundle identifier' in the application's documents Application Support directory.
        let urls = Foundation.FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    func clear() {
        let context: NSManagedObjectContext = self.viewContext
        let objectModel = self.persistentContainer.managedObjectModel
        let models = objectModel.entities
        for entity in models {
            if let entityName = entity.name {
                deleteAllObjects(entityName: entityName, context: context)
            }
        }
        do {
            try context.save()
        } catch {
            print("clear: ", error)
        }
        context.reset()
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        var url = urls[urls.count-1]
        url = url.appendingPathComponent("Application Support/MFCoreData.sqlite")
        do {
            if self.persistentContainer.persistentStoreCoordinator.persistentStore(for: url) != nil {
                try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            }
        } catch {
            print(error)
        }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
        
        do {
            try self.persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print(error)
        }
        
        do {
            try self.persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAllObjects(entityName: String, context: NSManagedObjectContext = MFCoreDataStack.shared.viewContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let results = try context.fetch(deleteFetch)
            for case let result as NSManagedObject in results {
                context.delete(result)
            }
        } catch {
            print("deleteAllObjects", error)
        }
    }
}

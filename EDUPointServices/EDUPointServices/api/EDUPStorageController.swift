//
//  EDUPStorageController.swift
//  EDUPointServices
//
//  Created by Alan Chu on 1/31/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData
import os.log

public final class EDUPStorageController {
    public static let shared = EDUPStorageController()
    
    public static let dbName = "EDUPointServices.sqlite"
    public static var sharedAppGroupURL: URL = {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.llambda.shared")!
    }()
    
    public fileprivate(set) var container: NSPersistentContainer
    
    public init() {
        let mom = NSManagedObjectModel.mergedModel(from: [Bundle(for: EDUPStorageController.self)])!
        container = NSPersistentContainer(name: "EDUPointServices", managedObjectModel: mom)
        
        let description: NSPersistentStoreDescription
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // RUNNING XCTESTS WILL USE IN MEMORY STORE.
            description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
        } else {
            // REGULAR ENVIRONMENT WILL USE THE PROPER SHARED APP GROUP DB.
            description = NSPersistentStoreDescription(url: EDUPStorageController.sharedAppGroupURL.appendingPathComponent(EDUPStorageController.dbName))
        }
        
        container.persistentStoreDescriptions = [description]
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Require the container to load before proceeding.
        let dispatch = DispatchGroup()
        
        dispatch.enter()
        container.loadPersistentStores { (description, error) in
            if let error = error {
                os_log("Error while trying to load persistent stores: %@", log: .default, type: .error, error as NSError)
                fatalError(error.localizedDescription)
            }
            dispatch.leave()
        }
        dispatch.wait()
    }
}


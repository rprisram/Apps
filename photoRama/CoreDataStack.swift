//
//  CoreDataStack.swift
//  photoRama
//
//  Created by macbook on 4/16/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    let managedObjectModelName : String
    
    required init(modelName : String) {
        managedObjectModelName = modelName
    }
    
    private lazy var managedObjectModel :NSManagedObjectModel = {
        let url = NSBundle.mainBundle().URLForResource(self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: url)!
    }()
    private lazy var applicationDocumentDirectory : NSURL = {
       let documents = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask)
        return documents.first!
    }()
    private lazy var coordinator : NSPersistentStoreCoordinator = {
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let storeURL = self.applicationDocumentDirectory.URLByAppendingPathComponent(pathComponent)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let store = try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true])
        return coordinator
    }()
    
    lazy var mainQueueContext : NSManagedObjectContext = {
       let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.name = "Managed Object COntext - UI"
        context.persistentStoreCoordinator = self.coordinator
        return context
    }()
    
    lazy var privateQueueContext : NSManagedObjectContext = {
       
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.parentContext = self.mainQueueContext
        moc.name = "Private Queue"
        return moc
    }()
    
    //MARK: Save Data in SQLLite
    func saveChanges() throws {
        var error : ErrorType?
        privateQueueContext.performBlockAndWait { () -> Void in
            if self.privateQueueContext.hasChanges{
                do{
                    try self.privateQueueContext.save()
                }catch let err {
                 error = err
                }
            }
           }
        if let error = error {
            throw error
        }
        if self.mainQueueContext.hasChanges {
            mainQueueContext.performBlockAndWait({ () -> Void in
                do
                {
                    try self.mainQueueContext.save()
                } catch let saveError{
                    error = saveError
                }
            })
        }
        if let error = error {
            throw error
        }
    }
}


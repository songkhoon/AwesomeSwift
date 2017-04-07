//
//  DatabaseController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 20/01/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit
import CoreData

class TableDataController {
    
    private let dataModelName = "CustomTableView"
    private let tableDataClassName = String(describing: TableData.self)
    private let tableItemClassName = String(describing: TableItem.self)

    private var _userTable:TableData?
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: self.dataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: "CustomTableView")
        } catch {
            print("CoreData: Unresolved error \(error)")
        }
        return nil
    }()
    
    lazy var managedObjectContext:NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    var userTableProperty:TableData? {
        get {
            if _userTable == nil {
                let userTableName = "User Table"
                let fetchRequest = NSFetchRequest<TableData>(entityName: tableDataClassName)
                do {
                    let result = try managedObjectContext.fetch(fetchRequest) as [TableData]
                    if result.count == 0 {
                        // create new user table
                        if let entity = NSEntityDescription.entity(forEntityName: tableDataClassName, in: managedObjectContext) {
                            if let data = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? TableData {
                                data.name = userTableName
                                data.lastUpdate = Date() as NSDate?
                                _userTable = data
                                try managedObjectContext.save()
                            }
                        }
                    } else {
                        if let index = result.index(where: { $0.name == userTableName }) {
                            _userTable = result[index]
                        }
                    }
                } catch let error as NSError {
                    print("could not initial TableData. \(error.userInfo)")
                }
            }
            return _userTable
        }
    }
    
    lazy var userTable:TableData? = {
        let userTableName = "User Table"
        let fetchRequest = NSFetchRequest<TableData>(entityName: self.tableDataClassName)
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest) as [TableData]
            if let index = result.index(where: { $0.name == userTableName }) {
                return result[index]
            } else {
                // create new user table
                if let entity = NSEntityDescription.entity(forEntityName: self.tableDataClassName, in: self.managedObjectContext) {
                    if let data = NSManagedObject(entity: entity, insertInto: self.managedObjectContext) as? TableData {
                        data.name = userTableName
                        data.lastUpdate = Date() as NSDate?
                        try self.managedObjectContext.save()
                        return data
                    }
                }
            }
        } catch let error as NSError {
            print("could not initial TableData. \(error.userInfo)")
        }
        return nil
    }()
    
    var userTableItem:[TableItem] {
        get {
            if let data = userTable, let items = data.items as? Set<TableItem> {
                return items.sorted(by: { $0.order < $1.order })
            }
            return []
        }
    }
    
    init() {
        if let tableData = fetchData(tableDataClassName) as? [TableData] {
            for data in tableData {
                print(data.objectID, data.name ?? "nil", data.lastUpdate ?? "nil")
            }
        }
        
        if let tableItem = fetchData(tableItemClassName) as? [TableItem] {
            for item in tableItem {
                print(item.objectID, item.name ?? "nil", item.createDate ?? "nil")
            }
        }

    }
    
    // MARK: - Core Data
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(_ entityName:String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as [NSManagedObject]
            return result
        } catch let error as NSError {
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return nil
    }
    
    func deleteItem(item:TableItem) {
        managedObjectContext.delete(item)
        var i:Int32 = 0
        for item in userTableItem {
            item.order = i
            i += 1
        }
        saveContext()
    }

    func deleteAllData(_ entityClassName:String) {
        if let datas = fetchData(entityClassName) {
            for item in datas {
                managedObjectContext.delete(item)
            }
            saveContext()
        }
    }
    
    func deleteTableItem() {
        deleteAllData(tableDataClassName)
    }

    func addTableData(_ itemName:String) {
        // update item
        guard let itemEntity = NSEntityDescription.entity(forEntityName: tableItemClassName, in: managedObjectContext) else {
            print("\(tableItemClassName) entity failure")
            return
        }
        guard let item = NSManagedObject(entity: itemEntity, insertInto: managedObjectContext) as? TableItem else {
            return
        }
        item.name = itemName
        item.createDate = Date() as NSDate?
        if let order = userTable?.items?.count {
            item.order = Int32(order)
        }
        // add relationship on table
        userTable?.addToItems(item)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("could not add data. \(error.userInfo)")
        }
    }
}

extension NSPersistentStoreCoordinator {
    
    /// NSPersistentStoreCoordinator error types
    public enum CoordinatorError: Error {
        /// .momd file not found
        case modelFileNotFound
        /// NSManagedObjectModel creation fail
        case modelCreationError
        /// Gettings document directory fail
        case storePathNotFound
    }
    
    /// Return NSPersistentStoreCoordinator object
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            throw CoordinatorError.storePathNotFound
        }
        
        do {
            let url = documents.appendingPathComponent("\(name).sqlite")
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true,
                            NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            throw error
        }
        
        return coordinator
    }
}


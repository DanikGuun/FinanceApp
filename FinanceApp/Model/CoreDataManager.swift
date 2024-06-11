//
//  CoreDataManager.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    private init() {}

    // MARK: - Entities
    var categoryEntity: NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "Category", in: CoreDataManager.shared.context)!
    }
    var operationEntity: NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "Operation", in: CoreDataManager.shared.context)!
    }
    
    // MARK: - Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinanceApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var context: NSManagedObjectContext = {persistentContainer.viewContext} ()
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

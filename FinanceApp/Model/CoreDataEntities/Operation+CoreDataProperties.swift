//
//  Operation+CoreDataProperties.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//
//

import Foundation
import CoreData


extension Operation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Operation> {
        return NSFetchRequest<Operation>(entityName: "Operation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var categoryID: UUID?
    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var notes: String?
    
}

extension Operation : Identifiable {
    
}

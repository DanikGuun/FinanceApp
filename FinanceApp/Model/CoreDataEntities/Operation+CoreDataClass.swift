//
//  Operation+CoreDataClass.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//
//

import Foundation
import CoreData

@objc(Operation)
public class Operation: NSManagedObject {
    public convenience init(id: UUID, categoryID: UUID, amount: Int, type: String, date: Date, notes: String){
        self.init(entity: CoreDataManager.shared.operationEntity, insertInto: CoreDataManager.shared.context)
        self.id = id
        self.categoryID = categoryID
        self.amount = Int32(amount)
        self.type = type
        self.date = date
        self.notes = notes
    }
}

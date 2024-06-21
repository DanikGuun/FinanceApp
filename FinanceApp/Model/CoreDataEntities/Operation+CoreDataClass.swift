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
    public convenience init(id: UUID, categoryID: UUID, amount: Double, date: Date, notes: String){
        self.init(entity: CoreDataManager.shared.operationEntity, insertInto: CoreDataManager.shared.context)
        self.id = id
        self.categoryID = categoryID
        self.amount = Double(amount)
        self.date = date
        self.notes = notes
    }
    var type: Model.OperationType{
        let category = Model.shared.getCategoryByUUID(self.categoryID!)!
        return Model.OperationType(rawValue: category.type!)!
    }
}

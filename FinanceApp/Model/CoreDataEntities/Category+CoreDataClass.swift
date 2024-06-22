//
//  Category+CoreDataClass.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject{
    public convenience init(id: UUID, name: String, type: String, icon: String, color: String){
        self.init(entity: CoreDataManager.shared .categoryEntity, insertInto: CoreDataManager.shared.context)
        self.id = id
        self.name = name
        self.type = type
        self.icon = icon
        self.color = color
    }
    public static func == (lhs: Category, rhs: Category) -> Bool{
        if lhs.id == rhs.id{
            return true
        }
        return false
    }
}

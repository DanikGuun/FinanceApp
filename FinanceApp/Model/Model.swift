//
//  Model.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import UIKit
import CoreData

class Model{
    static let shared = Model()
    private init(){}
    
    // MARK: Catrgories
    ///Добавление категории в persistanceContainer
    func addCategory(id: UUID, name: String, type: OperationType, icon: String, color: CGColor){
        let _ = Category(id: id, name: name, type: type.rawValue, icon: icon, color: colorToString(color))
        CoreDataManager.shared.saveContext()
    }
    /** 
    Получение всех категорий
    - Parameter type: тип нужных категорий, если nil, то возвращаются все
     */
    func getAllCategories(type: OperationType? = nil) -> [Category]{
        var categories: [Category] = []
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            let result = try CoreDataManager.shared.context.fetch(request)
            for category in result as! [Category] {
                if let type{ //если это нужный нам тип или нет разницы
                    if type.rawValue == category.type{ categories.append(category) }
                }
                else { categories.append(category) }
            }
        }
        catch {print(error); print("Что-то не так")}
        return categories
    }
    
    // MARK: Additions
    func colorToString(_ color: CGColor) -> String{
        guard let components = color.components else{return "Жопа"}
        return "\(components[0]) \(components[1]) \(components[2]) \(components[3])"
    }
    func stringToColor(_ str: String) -> CGColor{
        let components = str.split(separator: " ").map{ CGFloat(Double($0) ?? 0.0)}
        return CGColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
    
    // MARK: Enums
    ///Тип операций доход/расход
    public enum OperationType: String{
        case Expence = "Expence"
        case Income = "Income"
    }
}

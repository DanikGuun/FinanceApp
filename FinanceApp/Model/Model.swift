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
    func addCategory(id: UUID, name: String, type: String, icon: String, color: String){
        let _ = Category(id: id, name: name, type: type, icon: icon, color: color)
        CoreDataManager.shared.saveContext()
    }
    func deleteCategory(category: Category){
        CoreDataManager.shared.context.delete(category)
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Colors
    func getAvailableColors() -> [UIColor]{
        let mainColors = ColorManager.shared.getAvailableColors()
        var colors: [UIColor] = []
        
        return colors
    }
    /**
     Массив из случайных count цветов
     - Parameter count: Количество необходимых цветов
     - Берет все возможные цвета и удаляет случайные из них, пока массив не уменьшится до нужного размера
     */
    func getRandomColors(count: Int) -> [UIColor]{
        var colors = getAvailableColors()
        guard count >= 0 && count <= colors.count else{return []}
        while colors.count > count{
            let id = Int.random(in: 0..<colors.count)
            colors.remove(at: id)
        }
        return colors
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
    
    // MARK: Icons
    /**
     Получение всех иконок
     - Parameter type: тип иконок, если nil, то все
     */
    func getAllIcons(type: IconManager.IconCategories? = nil) -> [String]{
        var icons: [String] = []
        for icon in IconManager.shared.icons{
            if let type{ //если это нужный нам тип или нет разницы
                if type == icon.category{
                    icons.append(icon.name)
                }
            }
            else {icons.append(icon.name)}
        }
        return icons
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

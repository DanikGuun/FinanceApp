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
    
    var activeColor: UIColor? //для переноса между view при выборе из многих цветов
    
    
    // MARK: Catrgories
    ///Добавление категории в persistanceContainer
    func addCategory(id: UUID, name: String, type: String, icon: String, color: String){
        let _ = Category(id: id, name: name, type: type, icon: icon, color: color)
        CoreDataManager.shared.saveContext()
    }
    func deleteCategory(category: Category){
        removeOperationForCategory(category)
        CoreDataManager.shared.context.delete(category)
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
    
    func getRandomCategories(count: Int, type: OperationType, first: Category? = nil) -> [Category]{
        var categories = getAllCategories(type: type)
        categories.removeAll(where: {$0 == first})
        while categories.count > count{
            let id = Int.random(in: 0..<categories.count)
            categories.remove(at: id)
        }
        if let first{
            categories.insert(first, at: 0)
            // чтобы не было больше 6 элементов
            if count > 5{
                categories = categories.dropLast()
            }
        }
        return categories
    }
    
    func getCategoryByUUID(_ id: UUID?) -> Category?{
        for category in getAllCategories(){
            if category.id == id {return category}
        }
        return nil
    }
    
    // MARK: Operations
    func addOperation(categoryID: UUID, amount: Double, date: Date, notes: String){
        let _ = Operation(id: UUID(), categoryID: categoryID, amount: amount, date: date, notes: notes)
        CoreDataManager.shared.saveContext()
    }
    func getAllOperations() -> [Operation]{
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Operation")
            let result = try? CoreDataManager.shared.context.fetch(request)
            return result as! [Operation]
        }
    }
    func getOperationsForPeriod(_ period: DateInterval, type: OperationType? = nil, category: Category? = nil) -> [Operation]{
        var operations: [Operation] = []
        for operation in getAllOperations(){
            if period.contains(operation.date!){
                if type != nil{
                    if type == operation.type {operations.append(operation)}
                }
                else {operations.append(operation)}
            }
        }
        return operations
    }
    func removeOperationForCategory(_ category: Category){
        for operation in getAllOperations(){
            if category == getCategoryByUUID(operation.categoryID!){
                removeOperation(operation)
            }
        }
    }
    func removeOperation(_ operation: Operation){
        CoreDataManager.shared.context.delete(operation)
        CoreDataManager.shared.saveContext()
    }
    
    ///возвращает idCategory: [operation]
    func getCategoriedOperatioinsForPeriod(period: DateInterval, type: OperationType) -> Dictionary<UUID, [Operation]>{
        var categoriedOperation: Dictionary<UUID, [Operation]> = [:]
        for operation in getOperationsForPeriod(period, type: type){
            if categoriedOperation[operation.categoryID!] != nil{
                categoriedOperation[operation.categoryID!]?.append(operation)
            }
            else{
                categoriedOperation[operation.categoryID!] = [operation]
            }
        }
        return categoriedOperation
    }
    
    // MARK: Colors
    func getAvailableColors() -> [UIColor]{
        let mainColors = ColorManager.shared.getAvailableColors()
        var colors: [UIColor] = []
        for color in mainColors {
            let comp = color.cgColor.components!
            guard comp.count == 4 else {print(color); continue} //если чет не так с цветом
            for alpha in 0...6{
                let cg = CGColor(red: comp[0], green: comp[1], blue: comp[2], alpha: comp[3]-CGFloat(0.12*Double(alpha)))
                colors.append(UIColor(cgColor: cg))
            }
        }
        return colors
    }
    /**
     Массив из случайных count цветов
     - Parameter count: Количество необходимых цветов
     - Parameter otherwise: массив цветов, которых быть не должно
     - Берет все возможные цвета и удаляет случайные из них, пока массив не уменьшится до нужного размера
     */
    func getRandomColors(count: Int, otherwise: [UIColor]? = nil) -> [UIColor]{
        var colors = ColorManager.shared.getAvailableColors()
        guard count >= 0 && count <= colors.count else{return []}
        
        //убираем повторы
        colors.removeAll(where: {otherwise?.contains($0) ?? false})
        
        while colors.count > count{
            let id = Int.random(in: 0..<colors.count)
            colors.remove(at: id)
        }
        return colors
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
    /**
     получить имя иконки с UIImage, ибо встроенного нет, по сути из описания вытаскиваем
     
        Если попалась строка "symbol(system:  ", то запоминаем, что началось имя символа
            После идем до закрывающей скобки, которая означает, что имя закончилось и возвращаем это имя
     */
    func getSFName(of image: UIImage) -> String{
        let str = image.debugDescription
        var isNameStarted = false
        var nameStartIndex = str.startIndex
        
        for (index, symbol) in str.enumerated(){
            
            let start = str.index(str.startIndex, offsetBy: index)
            let end = str.index(start, offsetBy: 14)
            
            if str[start...end] == "symbol(system: "{
                isNameStarted = true
                nameStartIndex = str.index(after: end)
            }
            if isNameStarted && symbol == ")"{
                return String(str[nameStartIndex...str.index(before: start)])
            }
        }
        return ""
    }
    
    ///Получаем случайные count иконок
    func getRandomIcons(count: Int, otherwise: [String]? = nil) -> [String]{
        var icons = getAllIcons()
        
        if let otherwise {icons.removeAll {otherwise.contains($0)}} //если у нас есть иконка, удалеяем чтобы не повторялась
        
        guard count > 0 && icons.count > count else {return []}
        
        while icons.count > count{
            let id = Int.random(in: 0 ..< icons.count)
            icons.remove(at: id)
        }
            
        return icons
    }
    
    func getIconCategoriesCount() -> Int{return IconManager.IconCategories.allCases.count}
    
    ///Словарь типа категория-иконки
    func getIconsDictionary() -> Dictionary<IconManager.IconCategories, [String]>{
        let icons = IconManager.shared.icons
        var iconDictionary: Dictionary<IconManager.IconCategories, [String]> = [:]
        
        for icon in icons{
            if let _ = iconDictionary[icon.category]{
                iconDictionary[icon.category]!.append(icon.name)
            }
            else {
                iconDictionary[icon.category] = [icon.name]
            }
        }
        
        return iconDictionary
    }
    
    
    // MARK: Additions
    ///подвью с нужным тегом
    func getSubviewWithTag(viewToFind: UIView, tag: String) -> [UIView]{
        var arr: [UIView] = []
        for elem in viewToFind.subviews{
            if elem.restorationIdentifier == tag{
                arr.append(elem)
            }
            arr += getSubviewWithTag(viewToFind: elem, tag: tag)
        }
        return arr
    }
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

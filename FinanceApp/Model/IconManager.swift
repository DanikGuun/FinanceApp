//
//  IconManager.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 14.06.2024.
//

import Foundation
import UIKit

class IconManager{
    
    static let shared = IconManager()
    private init(){}
    
    internal struct Icon{
        let name: String //SysteName
        let category: IconCategories
    }
    
    static func getIconImage(name: String) -> UIImage{
        if let image = UIImage(systemName: name) {return image}
        return UIImage()
    }
    
    enum IconCategories: String, CaseIterable{
        case Vehicle = "Транспорт"
        case Food = "Еда"
        case Clothes = "Одежда"
        case Learning = "Обучение"
        case Sport = "Спорт"
        case Creative = "Творчество"
        case Job = "Работа"
        case Relax = "Отдых"
        case Other = "Другое"
        case Home = "Дом"
    }
    
    let icons: [Icon] = [
        Icon(name: "book", category: .Learning),
        Icon(name: "book.pages", category: .Learning),
        Icon(name: "bus.fill", category: .Vehicle),
        Icon(name: "fork.knife", category: .Food),
        Icon(name: "tshirt", category: .Clothes),
        Icon(name: "volleyball", category: .Sport),
        Icon(name: "frying.pan", category: .Food),
        Icon(name: "pencil.and.outline", category: .Creative),
        Icon(name: "folder.fill", category: .Job),
        Icon(name: "paperplane.fill", category: .Job),
        Icon(name: "books.vertical.fill", category: .Learning),
        Icon(name: "menucard", category: .Learning),
        Icon(name: "figure.2", category: .Relax),
        Icon(name: "snowboard.fill", category: .Relax),
        Icon(name: "surfboard.fill", category: .Relax),
        Icon(name: "skateboard.fill", category: .Relax),
        Icon(name: "gym.bag.fill", category: .Job),
        Icon(name: "bubble.fill", category: .Relax),
        Icon(name: "storefront.circle.fill", category: .Other),
        Icon(name: "washer.circle.fill", category: .Home),
        Icon(name: "lightbulb.min.fill", category: .Home),
        Icon(name: "steeringwheel.circle.fill", category: .Vehicle),
        Icon(name: "phone.fill", category: .Relax)]
}

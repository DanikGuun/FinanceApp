//
//  IconManager.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 14.06.2024.
//

import Foundation

class IconManager{
    
    static let shared = IconManager()
    private init(){}
    
    internal struct Icon{
        let name: String //SysteName
        let category: IconCategories
    }
    enum IconCategories: String{
        case Vehicle = "Транспорт"
        case Food = "Еда"
        case Clothes = "Одежда"
        case Learning = "обучение"
        case Sport = "Спорт"
    }
    
    let icons: [Icon] = [
        Icon(name: "book", category: .Learning),
        Icon(name: "book.pages", category: .Learning),
        Icon(name: "bus.fill", category: .Vehicle),
        Icon(name: "fork.knife", category: .Food),
        Icon(name: "tshirt", category: .Clothes),
        Icon(name: "volleyball", category: .Sport),
        Icon(name: "frying.pan", category: .Food)]
}

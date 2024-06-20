//
//  Appereances.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 06.06.2024.
//

import Foundation
import UIKit

public class Appereances{
    
    ///Делает небольшое подчеркивание снизу меню
    static func applyMenuBorder( _ view: UIView){
        view.layer.borderWidth = 0.33
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    /**
            Формат для отображения сумм
            - Parameter num: Сумма для форматирования
     */
    static func moneyFormat(_ num: Double) -> String{
        return num.formatted(.currency(code: "rub").locale(Locale(identifier: "ru_RU")).grouping(.automatic))
    }
    
    ///тень для объектов из меню с операциями, или не только
    static func applyShadow(_ view: UIView){
        view.layer.shadowColor = CGColor(red: 145/255, green: 143/255, blue: 143/255, alpha: 0.25)
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 4
    }
}

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
    static func applyMenuBorder( _ view: inout UIView){
        view.layer.borderWidth = 0.33
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
}

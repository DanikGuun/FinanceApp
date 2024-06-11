//
//  Model.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import UIKit
class Model{
    static let shared = Model()
    private init(){}
    
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
    enum OperationTypes: String{
        case Expence = "Expence"
        case Income = "Income"
    }
}

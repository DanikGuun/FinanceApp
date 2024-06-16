//
//  ColorManager.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 16.06.2024.
//

import Foundation
import UIKit

class ColorManager{
    static let shared = ColorManager()
    private init(){}
    
    func getAvailableColors() -> [UIColor]{
        return colors
    }
    private let colors: [UIColor] = [
        .systemBlue, .systemRed, .systemGreen, .systemOrange, .systemYellow,
        .systemPink, .systemTeal, .systemCyan, .systemBrown, .systemIndigo, .systemPurple,
        UIColor(red: 0, green: 0, blue: 0, alpha: 1) //black
    ]
}

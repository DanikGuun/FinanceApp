//
//  IconCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 14.06.2024.
//

import Foundation
import UIKit

class IconCell: UICollectionViewCell{
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var background: UIView! //общий фон для ячейки с отступом чтобы сделать тень
    @IBOutlet weak var iconBackground: UIView!
    
    internal func superSetup(){
        background.layer.cornerRadius = 14
        background.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
        background.layer.shadowRadius = 2
        
        iconBackground.layer.cornerRadius = 9
        icon.tintColor = .white
    }
    
    func setup(icon: UIImage, iconBackroundColor: UIColor, iconColor: UIColor = .white){
        superSetup()
        self.icon.image = icon
        self.icon.tintColor = iconColor
        iconBackground.backgroundColor = iconBackroundColor
    }
    
    func setIconBackgroundColor(_ color: UIColor){
        iconBackground.backgroundColor = color
    }
    func setIconTintColor(_ color: UIColor){
        icon.tintColor = color
    }
}

//
//  IconWithoutBackground.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 17.06.2024.
//

import Foundation
import UIKit

class IconWithoutBackgroundCell: UICollectionViewCell{
    
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setup(icon: UIImage, iconBackgroundColor: UIColor){
        self.iconImageView.image = icon
        self.iconBackgroundView.backgroundColor = iconBackgroundColor
        
        iconBackgroundView?.layer.cornerRadius = 14
        iconBackgroundView.layer.cornerRadius = 14
        iconBackgroundView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        iconBackgroundView.layer.shadowOpacity = 1
        iconBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        iconBackgroundView.layer.shadowRadius = 2
        
    }
}

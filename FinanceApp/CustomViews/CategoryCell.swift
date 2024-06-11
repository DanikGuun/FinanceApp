//
//  CategoryViewCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var background: UIView! //общий фон для ячейки с отступом чтобы сделать тень
    @IBOutlet weak var iconBackground: UIView!
    var category: Category!
    
    func setup(_ category: Category){
        self.category = category
        
        background.layer.cornerRadius = 14
        background.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
        background.layer.shadowRadius = 2
       
        iconBackground.layer.cornerRadius = 9
        iconBackground.backgroundColor = UIColor(cgColor: Model.shared.stringToColor(category.color!))
        
        icon.image = UIImage(systemName: category.icon!)
        icon.tintColor = .white
        
        name.adjustsFontSizeToFitWidth = true
        name.text = category.name!
    }
}

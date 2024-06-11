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
    var category: Category!
    
    func setup(_ category: Category){
        self.category = category
        layer.cornerRadius = 14
        icon.layer.cornerRadius = 9
        icon.image = UIImage(systemName: category.icon!)
        icon.backgroundColor = UIColor(cgColor: Model.shared.stringToColor(category.color!))
        name.adjustsFontSizeToFitWidth = true
        name.text = category.name!
    }
}

//
//  CategoryViewCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import UIKit

class CategoryCell: IconCell{
    @IBOutlet weak var name: UILabel!
    var category: Category?

    internal override func superSetup(){
        super.superSetup()
        name.adjustsFontSizeToFitWidth = true
    }
    
    func setup(_ category: Category){
        self.category = category
        superSetup()
        name.text = category.name!
        icon.image = IconManager.getIconImage(name: category.icon!)
        iconBackground.backgroundColor = UIColor(cgColor: Model.shared.stringToColor(category.color!))
    }
    func setup(name: String, icon: UIImage, iconBackroundColor: UIColor, iconColor: UIColor = .iconTint){
        superSetup()
        category = nil
        self.name.text = name
        self.icon.image = icon
        self.icon.tintColor = iconColor
        iconBackground.backgroundColor = iconBackroundColor
    }
}

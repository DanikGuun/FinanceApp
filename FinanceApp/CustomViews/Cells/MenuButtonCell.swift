//
//  MenuButtonViewCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 06.06.2024.
//

import Foundation
import UIKit

class MenuButtonCell: UICollectionViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var separator: UIView!
    var segouID: String! //для идентификатора перехода
    
    func setup(_ attributes: (name: String, systemName: String, segou: String), separatorNeed: Bool = false){
        nameLabel.text = attributes.name
        iconImage.image = IconManager.getIconImage(name: attributes.systemName)
        segouID = attributes.segou
        separator.isHidden = !separatorNeed
    }
}

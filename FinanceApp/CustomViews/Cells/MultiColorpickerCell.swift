//
//  MultiColorpickerCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 16.06.2024.
//

import Foundation
import UIKit

class MultiColorpickerCell: UICollectionViewCell{
    
    @IBOutlet weak var circleImageView: UIImageView!
    var color: UIColor {
        set{ circleImageView.tintColor = newValue}
        get{ return circleImageView.tintColor}
    }
    
    func setup(color: UIColor){
        self.color = color
    }
}

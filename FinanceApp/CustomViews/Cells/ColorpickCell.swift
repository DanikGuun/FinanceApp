//
//  ColorpickCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 17.06.2024.
//

import Foundation
import UIKit

class ColorpickCell: UICollectionViewCell{
    
    @IBOutlet weak var colorCircleImageView: UIImageView!
    @IBOutlet weak var colorPickStroke: UIImageView!
    var color: UIColor {
        get {return colorCircleImageView.tintColor}
        set {colorCircleImageView.tintColor = newValue}
    }
    
    
    func setup(color: UIColor, image: UIImage = UIImage(systemName: "circle.fill")!){
        self.colorCircleImageView.image = image
        self.color = color
        deselectColor()
    }
    func selectColor() {colorPickStroke.isHidden = false}
    func deselectColor() {colorPickStroke.isHidden = true}
}

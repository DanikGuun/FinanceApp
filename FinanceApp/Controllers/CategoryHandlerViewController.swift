//
//  CategoryHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 12.06.2024.
//

import Foundation
import UIKit

class CategoryHandlerViewController: UIViewController, ColorPickCircleDelegate{

    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var colorPickerStack: UIStackView!
    @IBOutlet weak var stackWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Appereances.applyMenuBorder(&menuBackground)
        addColors()
    }
    
    // MARK: color pickers
    func addColors(){
        let height = colorPickerStack.frame.height
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemMint]
        for c in colors{
            let colorPick = ColorPickCircle(color: c, frame: CGRect(x: 0, y: 0, width: height, height: height), delegate: self)
            colorPickerStack.addArrangedSubview(colorPick)
        }
        stackWidthConstraint.constant = CGFloat(colors.count)*(height)
    }
    func colorPicked(color: ColorPickCircle) {
        for item in colorPickerStack.arrangedSubviews as! [ColorPickCircle]{
            item.layer.borderWidth = 0
        }
        color.layer.borderWidth = 3
        color.layer.borderColor = CGColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    }
}

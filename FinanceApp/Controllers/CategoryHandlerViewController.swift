//
//  CategoryHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 12.06.2024.
//

import Foundation
import UIKit

class CategoryHandlerViewController: UIViewController, ColorPickCircleDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

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
        stackWidthConstraint.constant = CGFloat(colors.count + 1)*(height)
        
        //MoreButton
        let more = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: 100))
        more.image = UIImage(systemName: "ellipsis.circle.fill")
        more.tintColor = UIColor(cgColor: CGColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1))
        more.isUserInteractionEnabled = true
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(moreColorsPressed(_:)))
        more.addGestureRecognizer(recogniser)
        colorPickerStack.addArrangedSubview(more)
    }
    @objc func moreColorsPressed(_ sender: UIImage){
        print(3)
    }
    func colorPicked(color: ColorPickCircle) {
        for item in (colorPickerStack.arrangedSubviews as! [ColorPickCircle]).dropLast(){
            item.layer.borderWidth = 0
        }
        color.layer.borderWidth = 3
        color.layer.borderColor = UIColor(named: "ColorPicked")?.cgColor
    }
    
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

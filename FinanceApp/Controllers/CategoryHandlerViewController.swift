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
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    
    var activeColor: UIColor = .clear
    var icons: [String] = [] //иконки, чтобы при смене цвета их брать оттуда же
    var activeIcon: String? //название иконки, если редачим категорию, чтобы она первая была
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Appereances.applyMenuBorder(&menuBackground)
        addColors()
        icons = getRandomIcons()
        setupIconsCollection()
        setupApplyButton()
    }
    
    // MARK: color pickers
    func addColors(){
        let height = colorPickerStack.frame.height
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemMint]
        for c in colors{
            let colorPick = ColorPickCircle(color: c, frame: CGRect(x: 0, y: 0, width: height, height: height), delegate: self)
            colorPickerStack.addArrangedSubview(colorPick)
        }
        if activeColor == UIColor.clear{
            //выбираем первый цвет, если переход был от категории, то цвет не меняем, ибо он будет поставленный
            colorPicked(color: colorPickerStack.arrangedSubviews[0] as! ColorPickCircle)
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
    
    func colorPicked(color: ColorPickCircle) {
        for item in (colorPickerStack.arrangedSubviews as! [ColorPickCircle]).dropLast(){
            item.layer.borderWidth = 0
        }
        color.layer.borderWidth = 3
        color.layer.borderColor = UIColor(named: "ColorPicked")?.cgColor
        activeColor = color.color
        
        iconsCollectionView.reloadData()
    }
    
    @objc func moreColorsPressed(_ sender: UIImage){
        print(3)
    }
    
    // MARK: Collection View
    func setupIconsCollection(){
        iconsCollectionView.delegate = self
        iconsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = iconsCollectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCell
        switch indexPath.item{//свитч чтобы при необходимости взять нужную первую иконку и последнюю поменять
            case 0:
            if let activeIcon{
                cell.setup(icon: UIImage(systemName: activeIcon)!, iconBackroundColor: activeColor)
            }
            else{ cell.setup(icon: UIImage(systemName: icons[indexPath.item])!, iconBackroundColor: activeColor) } //default
            case 5:
                cell.setup(icon: UIImage(systemName: "ellipsis.circle")!, iconBackroundColor: .clear, iconColor: activeColor)
            default:
                cell.setup(icon: UIImage(systemName: icons[indexPath.item])!, iconBackroundColor: activeColor)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = collectionView.cellForItem(at: indexPath) as! IconCell
        let background = getSubviewWithTag(viewToFind: selected, tag: "iconBackground")
        background[0].layer.borderColor = UIColor(named: "IconPickedBorder")?.cgColor
        background[0].layer.borderWidth = 2
        background[0].backgroundColor = UIColor(named: "IconPickedBackground")
        //открашиваем остальные
        for cell in collectionView.visibleCells{
            if cell != selected{
                let background = getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
                background[0].layer.borderColor = UIColor.clear.cgColor
                background[0].layer.borderWidth = 0
                background[0].backgroundColor = UIColor(named: "CellBackround")
            }
        }
    }
    
    // MARK: Additions
    ///Получаем случайные 6 иконок
    func getRandomIcons() -> [String]{
        var allIcons = Model.shared.getAllIcons()
        var icons: [String] = []
        for _ in 0..<6{
            let element = allIcons.randomElement()
            icons.append(element!)
            allIcons.removeAll(where: {$0 == element})
        }
        return icons
    }
    ///настраиваем кнопку
    func setupApplyButton(){
        
    }
    
    ///подвью с id
    func getSubviewWithTag(viewToFind: UIView, tag: String) -> [UIView]{
        var arr: [UIView] = []
        for elem in viewToFind.subviews{
            if elem.restorationIdentifier == tag{
                arr.append(elem)
            }
            arr += getSubviewWithTag(viewToFind: elem, tag: tag)
        }
        return arr
    }
}

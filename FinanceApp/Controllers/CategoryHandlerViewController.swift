//
//  CategoryHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 12.06.2024.
//

import Foundation
import UIKit

class CategoryHandlerViewController: UIViewController, ColorPickCircleDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var categoryTypeSegmentedConrol: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var colorPickerStack: UIStackView!
    @IBOutlet weak var stackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    
    private var activeColor: UIColor = .clear
    private var activeIcon: String? //название иконки, если редачим категорию, чтобы она первая была
    private var icons: [String] = [] //иконки, чтобы при смене цвета их брать оттуда же
    var currentCategory: Category? //категория, если создаем, а не редачим, то nil
    var currentSegmentedIndex: Int = 0 //для Указания изначальной категории
    
    override func viewDidLoad(){
        super.viewDidLoad()
        nameTextField.text = currentCategory?.name ?? ""
        Appereances.applyMenuBorder(&menuBackground)
        addColors()
        icons = getRandomIcons()
        setupIconsCollection()
        setupApplyButton()
        setupTextField()
        
        if let currentCategory{
            if currentCategory.type == Model.OperationType.Expence.rawValue{categoryTypeSegmentedConrol.selectedSegmentIndex = 0}
            else {categoryTypeSegmentedConrol.selectedSegmentIndex = 1}
        }
        else{categoryTypeSegmentedConrol.selectedSegmentIndex = currentSegmentedIndex}
    }
    
    // MARK: color pickers
    func addColors(){
        let height = colorPickerStack.frame.height
        var colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemMint]
        
        if let currentCategory{ //если редачим, вставляем первый цвет
            colors.insert(UIColor(cgColor: Model.shared.stringToColor(currentCategory.color!)), at: 0)
        }
        
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
        activeIcon = currentCategory?.icon
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
                selectCell(cell: cell, collection: collectionView)
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
        view.endEditing(true)
        if indexPath.item != 5{
            let selected = collectionView.cellForItem(at: indexPath) as! IconCell
            selectCell(cell: selected, collection: collectionView)
        }
    }
    
    func selectCell(cell: UICollectionViewCell, collection: UICollectionView){
        let background = getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
        background[0].layer.borderColor = UIColor(named: "IconPickedBorder")?.cgColor
        background[0].layer.borderWidth = 2
        background[0].backgroundColor = UIColor(named: "IconPickedBackground")
        //открашиваем остальные
        for otherCell in collection.visibleCells{
            if otherCell != cell{
                let background = getSubviewWithTag(viewToFind: otherCell, tag: "iconBackground")
                background[0].layer.borderColor = UIColor.clear.cgColor
                background[0].layer.borderWidth = 0
                background[0].backgroundColor = UIColor(named: "CellBackround")
            }
        }
        let selectedImage = (getSubviewWithTag(viewToFind: cell, tag: "icon")[0] as! UIImageView).image
        activeIcon = getSFName(of: selectedImage!)
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
        applyButton.layer.cornerRadius = 25
        var conf = applyButton.configuration
        if let currentCategory{
            conf?.image = UIImage(systemName: "pencil.line")
            conf?.title = "Применить"
        }
        else{
            conf?.image = UIImage(systemName: "plus.square")
            conf?.title = "Добавить"
        }
        applyButton.configuration = conf
    }
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text!
        let color = Model.shared.colorToString(activeColor.cgColor)
        let categoryType: String
        if categoryTypeSegmentedConrol.selectedSegmentIndex == 0{categoryType = Model.OperationType.Expence.rawValue}
        else {categoryType = Model.OperationType.Income.rawValue}
        if let currentCategory{
            currentCategory.color = color
            currentCategory.name = name
            currentCategory.icon = activeIcon
            currentCategory.type = categoryType
        }
        else {Model.shared.addCategory(id: UUID(), name: name, type: categoryType, icon: activeIcon!, color: color)}
        CoreDataManager.shared.saveContext()
        navigationController?.popViewController(animated: true) //закрытие страницы
    }
    
    //TextField
    func setupTextField(){
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     получить имя иконки с UIImage, ибо встроенного нет, по сути из описания вытаскиваем
     
        Если попалась строка "symbol(system:  ", то запоминаем, что началось имя символа
            После идем до закрывающей скобки, которая означает, что имя закончилось и возвращаем это имя
     */
    func getSFName(of image: UIImage) -> String{
        let str = image.debugDescription
        var isNameStarted = false
        var nameStartIndex = str.startIndex
        
        for (index, symbol) in str.enumerated(){
            
            let start = str.index(str.startIndex, offsetBy: index)
            let end = str.index(start, offsetBy: 14)
            
            if str[start...end] == "symbol(system: "{
                isNameStarted = true
                nameStartIndex = str.index(after: end)
            }
            if isNameStarted && symbol == ")"{
                return String(str[nameStartIndex...str.index(before: start)])
            }
        }
        return ""
    }
    
    ///подвью с нужным тегом
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
    
    ///Чтобы при повторном нажатии убиралась клавиатура
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

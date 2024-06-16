//
//  CategoryHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 12.06.2024.
//

import Foundation
import UIKit

class CategoryHandlerViewController: UIViewController, ColorPickCircleDelegate, MultiColorpickerParent, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, IconpickerParent{

    @IBOutlet weak var viewControllerTitle: UILabel!
    @IBOutlet weak var categoryTypeSegmentedConrol: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var colorPickerStack: UIStackView!
    @IBOutlet weak var stackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var deleteCategoryButton: UIButton!
    
    private var activeColor: UIColor?
    private var activeIcon: String? //название иконки, если редачим категорию, чтобы она первая была
    private var icons: [String] = [] //иконки, чтобы при смене цвета их брать оттуда же
    var currentCategory: Category? //категория, если создаем, а не редачим, то nil
    var currentSegmentedIndex: Int = 0 //для Указания изначальной категории
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let currentCategory{
            //значение для сегмента
            if currentCategory.type == Model.OperationType.Expence.rawValue{categoryTypeSegmentedConrol.selectedSegmentIndex = 0}
            else {categoryTypeSegmentedConrol.selectedSegmentIndex = 1}
            activeColor = UIColor(cgColor: Model.shared.stringToColor(currentCategory.color!))
            activeIcon = currentCategory.icon
        }
        else{categoryTypeSegmentedConrol.selectedSegmentIndex = currentSegmentedIndex}
        
        Appereances.applyMenuBorder(&menuBackground)
        icons = Model.shared.getRandomIcons(count: 5, otherwise: activeIcon)
        
        viewControllerTitle.text = currentCategory?.name ?? "Новая категория"
        viewControllerTitle.adjustsFontSizeToFitWidth = true
        nameTextField.text = currentCategory?.name ?? ""
        addColors()
        setupIconsCollection()
        setupApplyButton()
        setupTextField()
        setupDeleteCateforyButton()
    }
    
    // MARK: color pickers
    func addColors(){
        
        for item in colorPickerStack.arrangedSubviews {colorPickerStack.removeArrangedSubview(item)} //почистить цвета
        
        let height = colorPickerStack.frame.height
        var colors: [UIColor] = Model.shared.getRandomColors(count: 5)
        
        if let activeColor{ //если редачим, вставляем первый цвет
            colors.insert(activeColor, at: 0)
        }
        
        for c in colors{
            let colorPick = ColorPickCircle(color: c, frame: CGRect(x: 0, y: 0, width: height, height: height), delegate: self)
            colorPickerStack.addArrangedSubview(colorPick)
        }
        //выбираем первый цвет, если переход был от категории, то цвет не меняем, ибо он будет поставленный
        colorPicked(color: colorPickerStack.arrangedSubviews[0] as! ColorPickCircle)
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
        
        for (index, iconCell) in iconsCollectionView.visibleCells.enumerated(){
            let cell = iconCell as! IconCell
            if index != 5{ //если эта не иконка "больше" красим задний фон, иначе - саму иконку
                cell.setIconBackgroundColor(color.color)
            }
            else {cell.setIconTintColor(color.color)}
        }
    }
    
    func colorPickedFromMultiMenu(color: UIColor) {
        activeColor = color
        addColors()
    }
    
    @objc func moreColorsPressed(_ sender: UIImage){
        performSegue(withIdentifier: "colorpickerSegue", sender: nil)
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
                cell.setup(icon: UIImage(systemName: activeIcon)!, iconBackroundColor: activeColor!)
                selectCell(cell: cell, collection: collectionView)
            }
            else{ cell.setup(icon: UIImage(systemName: icons[indexPath.item])!, iconBackroundColor: activeColor!) } //default
            case 5:
            cell.setup(icon: UIImage(systemName: "ellipsis.circle")!, iconBackroundColor: .clear, iconColor: activeColor!)
            default:
            cell.setup(icon: UIImage(systemName: icons[indexPath.item])!, iconBackroundColor: activeColor!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        if indexPath.item != 5{
            let selected = collectionView.cellForItem(at: indexPath) as! IconCell
            selectCell(cell: selected, collection: collectionView)
            unSelectCells(otherwise: selected)
        }
        else{ performSegue(withIdentifier: "iconSegue", sender: nil)}//нажато на меню иконок
    }
    
    func selectCell(cell: UICollectionViewCell, collection: UICollectionView){
        let background = getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
        background[0].layer.borderColor = UIColor(named: "IconPickedBorder")?.cgColor
        background[0].layer.borderWidth = 2
        background[0].backgroundColor = UIColor(named: "IconPickedBackground")
        
        let selectedImage = (getSubviewWithTag(viewToFind: cell, tag: "icon")[0] as! UIImageView).image
        activeIcon = Model.shared.getSFName(of: selectedImage!)
    }
    
    func unSelectCells(otherwise selectedCell: UICollectionViewCell? = nil){
        for cell in iconsCollectionView.visibleCells{
            if cell != selectedCell{
                let background = getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
                background[0].layer.borderColor = UIColor.clear.cgColor
                background[0].layer.borderWidth = 0
                background[0].backgroundColor = UIColor(named: "CellBackround")
            }
        }
    }
    
    // MARK: Icons
    func pickIconFromMenu(icon: String) {
        activeIcon = icon
        unSelectCells()
        iconsCollectionView.reloadData()
    }
    
    // MARK: Additions

    ///настраиваем кнопку добавления
    func setupApplyButton(){
        applyButton.layer.cornerRadius = 25
        var conf = applyButton.configuration
        if currentCategory != nil{
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
        let color = Model.shared.colorToString(activeColor!.cgColor)
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
    
    //настраиваем кнопку удаления
    func setupDeleteCateforyButton(){
        if currentCategory != nil {deleteCategoryButton.isHidden = false}
        else {deleteCategoryButton.isHidden = true}
    }
    @IBAction func removeButtonPressed() {
        //бахаем алерт
        if let currentCategory{
            let alert = UIAlertController(title: "Удаляем категорию?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Нет", style: .default))
            alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { alert in
                Model.shared.deleteCategory(category: currentCategory)
                self.navigationController?.popViewController(animated: true)}))
            self.present(alert, animated: true)
        }
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
    
    // MARK: Segue preaparing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "colorpickerSegue":
            let controller = segue.destination as! MultiColorpickerViewController
            controller.parentController = self
        case "iconSegue":
            let controller = segue.destination as! IconpickerViewController
            controller.parentView = self
            controller.iconBackgroundColor = activeColor
        default: break
        }
    }
}

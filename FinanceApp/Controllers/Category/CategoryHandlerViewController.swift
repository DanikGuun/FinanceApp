//
//  CategoryHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 12.06.2024.
//

import Foundation
import UIKit

class CategoryHandlerViewController: UIViewController, MultiColorpickerParent, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, IconpickerParent, UICollectionViewDelegateFlowLayout, ColorpickerDelegate{

    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var categoryTypeSegmentedConrol: UISegmentedControl!
    @IBOutlet weak var colorPickerCollectionView: ColorpickerCollectionView!
    @IBOutlet weak var deleteCategoryButton: UIButton!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var viewControllerTitle: UILabel!
    
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
        
        Appereances.applyMenuBorder(menuBackground)
        icons = Model.shared.getRandomIcons(count: 5, otherwise: [activeIcon ?? ""])
        
        viewControllerTitle.text = currentCategory?.name ?? "Новая категория"
        viewControllerTitle.adjustsFontSizeToFitWidth = true
        nameTextField.text = currentCategory?.name ?? ""
        setupIconsCollection()
        setupApplyButton()
        setupTextField()
        setupDeleteCateforyButton()
        colorPickerCollectionView.parentView = self
        
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
                }
                else{ cell.setup(icon: UIImage(systemName: icons[indexPath.item])!, iconBackroundColor: activeColor!) } //default
                selectCell(cell: cell)
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
            selectCell(cell: selected)
            unSelectCells(otherwise: selected)
        }
        else{ performSegue(withIdentifier: "iconSegue", sender: nil)}//нажато на меню иконок
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func selectCell(cell: UICollectionViewCell){
        let background = Model.shared.getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
        background[0].layer.borderColor = UIColor(named: "IconPickedBorder")?.cgColor
        background[0].layer.borderWidth = 2
        background[0].backgroundColor = UIColor(named: "IconPickedBackground")
        
        let selectedImage = (Model.shared.getSubviewWithTag(viewToFind: cell, tag: "icon")[0] as! UIImageView).image
        activeIcon = Model.shared.getSFName(of: selectedImage!)
    }
    
    func unSelectCells(otherwise selectedCell: UICollectionViewCell? = nil){
        for cell in iconsCollectionView.visibleCells{
            if cell != selectedCell{
                let background = Model.shared.getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
                background[0].layer.borderColor = UIColor.clear.cgColor
                background[0].layer.borderWidth = 0
                background[0].backgroundColor = UIColor(named: "CellBackround")
            }
        }
    }
    
    // MARK: Icons
    func pickIconFromMenu(icon: String) {
        activeIcon = icon
        //убираем повторяющиеся иконки
        for (index, ic) in icons.enumerated(){
            if ic == activeIcon{
                icons[index] = Model.shared.getRandomIcons(count: 1, otherwise: icons)[0]
            }
        }
        
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
    // MARK: ColorPicker Collection

    func colorPick(_ color: UIColor) {
        activeColor = color
        
        for (index, icon) in iconsCollectionView.visibleCells.enumerated(){
            let cell = icon as! IconCell
            //если не ласт иконка
            if index != iconsCollectionView.visibleCells.count-1 {cell.setIconBackgroundColor(color)}
            else {cell.setIconTintColor(color)}
        }
    }
    
    func colorPickedFromMultiMenu(color: UIColor) {
        activeColor = color
        colorPick(color)
        colorPickerCollectionView.inserColor(color)
    }
    
    func moreColorsPressed(){
        performSegue(withIdentifier: "colorpickerSegue", sender: nil)
    }
}

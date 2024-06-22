//
//  OperationHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 20.06.2024.
//

import Foundation
import UIKit

class OperationHandlerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var operationTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var opertaionDatePicker: UIDatePicker!
    
    var notesToDateConstraint: NSLayoutConstraint!
    var notesToKeyboardConstraint: NSLayoutConstraint!
    
    var currentOperation: Operation?
    var categories: [Category] = []

    var activeOperationType: Model.OperationType{
        get{
            if operationTypeSegmentedControl.selectedSegmentIndex == 0 {return .Expence}
            else {return .Income}
        }
        set{
            if newValue == .Expence {operationTypeSegmentedControl.selectedSegmentIndex = 0}
            else {operationTypeSegmentedControl.selectedSegmentIndex = 1}
        }
    }//активная категория через segmentedControl
    var activeCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appereances.applyMenuBorder(menuBackgroundView)
        setupOperationType() //задание начального типа
        setupCategories() //стартовая генерация категорий
        setupApplyButton()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        notesTextField.delegate = self
        notesToDateConstraint = notesTextField.topAnchor.constraint(equalTo: opertaionDatePicker.bottomAnchor, constant: 18)
        notesToKeyboardConstraint = notesTextField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -30)
        notesToDateConstraint.isActive = true
    }
    
    // MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categories.count >= 6 {return 6}
        else {return categories.count + 1}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "operationCategoryCell", for: indexPath) as! CategoryCell
        
        if indexPath.row == 0 && categories.count != 0{
            cell.setup(categories[0])
            if let operation = currentOperation{
                if activeOperationType == operation.type{
                    selectCell(cell: cell)
                }
            }
        }
        else if indexPath.row == categories.count || categories.count == 0{
            cell.setup(name: "Больше", icon: UIImage(systemName: "ellipsis.circle")!, iconBackroundColor: .white, iconColor: .systemBlue)
        }
        else{
            cell.setup(categories[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        unSelectCells()
        let selected = collectionView.cellForItem(at: indexPath) as! CategoryCell
        selectCell(cell: selected)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = width * (141/118)
        return CGSize(width: width, height: height)
    }
    
    func unSelectCells(otherwise selectedCell: UICollectionViewCell? = nil){
        for cell in categoriesCollectionView.visibleCells{
            let background = Model.shared.getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
            background[0].layer.borderColor = UIColor.clear.cgColor
            background[0].layer.borderWidth = 0
            background[0].backgroundColor = UIColor(named: "CellBackround")
        }
    }
    
    func selectCell(cell: CategoryCell){
        //если это не кнопка больше
        if cell.category != nil{
            let background = Model.shared.getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
            background[0].layer.borderColor = UIColor(named: "IconPickedBorder")?.cgColor
            background[0].layer.borderWidth = 2
            background[0].backgroundColor = UIColor(named: "IconPickedBackground")
            activeCategory = cell.category
        }
        
    }

    // MARK: SegmentedControl
    
    @IBAction func operationTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            activeOperationType = .Expence
        }
        else {activeOperationType = .Income}
        activeCategory = nil
        setupCategories()
        unSelectCells()
        categoriesCollectionView.reloadData()
    }
    
    // MARK: Notes TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        notesToDateConstraint.isActive = true
        notesToKeyboardConstraint.isActive = false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        notesToDateConstraint.isActive = false
        notesToKeyboardConstraint.isActive = true
        return true
    }
    
    // MARK: Additions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    ///настраиваем кнопку добавления
    func setupApplyButton(){
        applyButton.layer.cornerRadius = 25
        var conf = applyButton.configuration
        if currentOperation != nil{
            conf?.image = UIImage(systemName: "pencil.line")
            conf?.title = "Применить"
        }
        else{
            conf?.image = UIImage(systemName: "plus.square")
            conf?.title = "Добавить"
        }
        applyButton.configuration = conf
    }
    
    func setupOperationType(){
        if let operation = currentOperation{
            activeOperationType = operation.type
        }
        activeOperationType = .Expence
    }
    
    /**
     Настраиваем первичный список категорий
      - Parameter count: Количество категорий
     - Parameter type: Тип текущей операций
     */
    func setupCategories(){
        categories = Model.shared.getRandomCategories(count: 5, type: activeOperationType)
        //добавляем имеющуюся, только если тип операций совпадает
        if let operation = currentOperation{
            if operation.type == activeOperationType{
                categories[0] = Model.shared.getCategoryByUUID(operation.id!)!
            }
        }
    }
}

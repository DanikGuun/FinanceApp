//
//  OperationHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 20.06.2024.
//

import Foundation
import UIKit

class OperationHandlerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, CategoriesPickParent{

    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var operationTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var emptyAmountWarning: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var emptyCategoryWarning: UIView!
    @IBOutlet weak var opertaionDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
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
    var needSelectFirstCategory = false //чтобы выделять первую категорию, если выбираем из меню
    //для инициализации стартовых значений
    var startOperationType = 0
    var startDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appereances.applyMenuBorder(menuBackgroundView)
        setupOperationType() //задание начального типа
        setupCategories() //стартовая генерация категорий
        setupApplyButton()
        setupRemoveButton()
        setupDate()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        notesTextField.delegate = self
        
        //чтобы переносить поле для заметок под клавиатуру
        notesToDateConstraint = notesTextField.topAnchor.constraint(equalTo: opertaionDatePicker.bottomAnchor, constant: 18)
        notesToKeyboardConstraint = notesTextField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -30)
        notesToDateConstraint.isActive = true
        
        emptyAmountWarning.layer.cornerRadius = 5
        emptyCategoryWarning.layer.cornerRadius = 5
        
        amountTextField.text = currentOperation?.amount.formatted(.number.grouping(.never)) ?? ""
        notesTextField.text = currentOperation?.notes
    
    }
    
    // MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categories.count >= 6 {return 6}
        else {return categories.count + 1}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "operationCategoryCell", for: indexPath) as! CategoryCell
        
        //если это первая ячейка и в категориях есть хоть одна
        if indexPath.row == 0 && categories.count != 0{
            cell.setup(categories[0])
            if let operation = currentOperation{
                if activeOperationType == operation.type{
                    selectCell(cell: cell)
                }
            }
            else if needSelectFirstCategory{
                selectCell(cell: cell)
                needSelectFirstCategory = false
            }
        }
        //если это последняя
        else if indexPath.row == categories.count || categories.count == 0{
            cell.setup(name: "Больше", icon: UIImage(systemName: "ellipsis.circle")!, iconBackroundColor: .clear, iconColor: .systemBlue)
        }
        else{
            cell.setup(categories[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        let selected = collectionView.cellForItem(at: indexPath) as! CategoryCell
        
        if Model.shared.getSFName(of: selected.icon.image!) == "ellipsis.circle"{
            performSegue(withIdentifier: "pickCategorySegue", sender: nil)
        }
        else {
            unSelectCells()
            selectCell(cell: selected)
        }
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        notesToDateConstraint.isActive = false
        notesToKeyboardConstraint.isActive = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        notesToDateConstraint.isActive = true
        notesToKeyboardConstraint.isActive = false
    }
    
    // MARK: Apply Button
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
    
    @IBAction func applyButton(_ sender: UIButton) {
        func animateEmptyField(_ emptyView: UIView){
            emptyView.backgroundColor = UIColor(named: "EmptyField")
            UIView.animate(withDuration: 0.8, animations: {
                emptyView.backgroundColor = UIColor.clear
            })
        }
        var isFull = true //Если все поля заполнены
        
        //если не заполнена сумма, то заполняем и то же с категориями
        if amountTextField.text?.isEmpty ?? true {animateEmptyField(emptyAmountWarning); isFull = false}
        if activeCategory == nil {animateEmptyField(emptyCategoryWarning); isFull = false}
        
        if isFull{
            let amount = Double(amountTextField.text!) ?? 0.0
            let date = opertaionDatePicker.date
            let notes = notesTextField.text ?? ""
            
            if let currentOperation{
                currentOperation.categoryID = activeCategory!.id
                currentOperation.amount = amount
                currentOperation.date = date
                currentOperation.notes = notes
            }
            else {Model.shared.addOperation(categoryID: activeCategory!.id!, amount: amount, date: date, notes: notes)}
            CoreDataManager.shared.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Remove Button
    func setupRemoveButton(){
        if currentOperation != nil {removeButton.isHidden = false}
        else {removeButton.isHidden = true}
    }
    @IBAction func removeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Удаляем операцию?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: {_ in}))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { _ in
            Model.shared.removeOperation(self.currentOperation!)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: Additions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupOperationType(){
        if let operation = currentOperation{
            activeOperationType = operation.type
        }
        else{
            if startOperationType == 0 {activeOperationType = .Expence}
            else {activeOperationType = .Income}
        }
    }
    
    /**
     Настраиваем первичный список категорий
      - Parameter count: Количество категорий
     - Parameter type: Тип текущей операций
     */
    func setupCategories(){
        let category = Model.shared.getCategoryByUUID(currentOperation?.categoryID)
        categories = Model.shared.getRandomCategories(count: 5, type: activeOperationType, first: category)
    }
    
    func setupDate(){
        opertaionDatePicker.maximumDate = Date()
        if let currentOperation{
            opertaionDatePicker.date = currentOperation.date!
        }
        else{
            opertaionDatePicker.setDate(startDate, animated: true)
        }
    }
    
    func categoryPick(_ category: Category) {
        //если выбранная категория есть в списке, то не дропаем последнюю, а только удаляем первую
        unSelectCells()
        if categories.contains(category) == false{
            categories = categories.dropLast()
        }
        categories.removeAll(where: {$0 == category})
        categories.insert(category, at: 0)
        needSelectFirstCategory = true
        categoriesCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CategoryPickViewController{
            destination.categoryType = activeOperationType
            destination.parentOperationController = self
        }
    }
}

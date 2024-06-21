//
//  OperationHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 20.06.2024.
//

import Foundation
import UIKit

class OperationHandlerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet var menuBackgroundView: UIView!
    @IBOutlet var operationTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    
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
            if cell != selectedCell{
                let background = Model.shared.getSubviewWithTag(viewToFind: cell, tag: "iconBackground")
                background[0].layer.borderColor = UIColor.clear.cgColor
                background[0].layer.borderWidth = 0
                background[0].backgroundColor = UIColor(named: "CellBackround")
            }
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

    
    // MARK: Additions
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
            let category = Model.shared.getCategoryByUUID(operation.categoryID!)
            activeOperationType = Model.OperationType(rawValue: category!.type!)!
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
        if let operation = currentOperation{
            categories[0] = Model.shared.getCategoryByUUID(operation.id!)!
        }
    }
}

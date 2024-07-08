//
//  OperationsStoryViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 07.07.2024.
//

import UIKit

class OperationsStoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var operationsCollectionView: UICollectionView!
    
    var category: Category?
    var interval: DateInterval!
    var operationsType: Model.OperationType!
    
    var currentOperations: Dictionary<Date, [Operation]> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOperations()
        
        operationsCollectionView.delegate = self
        operationsCollectionView.dataSource = self
    }
    
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentOperations.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionsHeaderView
        let sectionDateIndex = currentOperations.keys.index(currentOperations.startIndex, offsetBy: indexPath.section)
        header.setup(name: currentOperations.keys[sectionDateIndex].formatted(.dateTime.day().month().year()))
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentDateIndex = currentOperations.keys.index(currentOperations.startIndex, offsetBy: section)
        let currentKey = currentOperations.keys[currentDateIndex]
        return currentOperations[currentKey]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentDateIndex = currentOperations.keys.index(currentOperations.startIndex, offsetBy: indexPath.section)
        let currentKey = currentOperations.keys[currentDateIndex]
        let operations = currentOperations[currentKey]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "operationStoryCell", for: indexPath) as! OperationStoryCell
        cell.setup(operation: operations![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        let height = collectionView.frame.height / 10
        return CGSize(width: width, height: height)
    }
    
    //MARK: Additions
    func setupOperations(){
        let operations = Model.shared.getOperationsForPeriod(interval, type: operationsType)
        for operation in operations {
            //если элемент уже есть, то добавляем в массив, если нет, то создаем новый
            if let currentOperation = currentOperations[operation.date!]{
                currentOperations[operation.date!]?.append(operation)
            }
            else{
                currentOperations[operation.date!] = [operation]
            }
        }
    }
}

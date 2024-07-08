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
    
    var currentOperations: [(date: Date, operations: [Operation])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOperations()
        
        operationsCollectionView.delegate = self
        operationsCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupOperations()
        operationsCollectionView.reloadData()
    }
    
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentOperations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionsHeaderView
        let date = currentOperations[indexPath.section].date
        let formatted = date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU")))
        header.setup(name: formatted)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return currentOperations[section].operations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let operations = currentOperations[indexPath.section].operations
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "operationStoryCell", for: indexPath) as! OperationStoryCell
        cell.setup(operation: operations[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OperationStoryCell
        performSegue(withIdentifier: "editOperationSegue", sender: cell.currentOperation)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        let height = collectionView.frame.height / 10
        return CGSize(width: width, height: height)
    }
    
    //MARK: Additions
    func setupOperations(){
        let operations = Model.shared.getOperationsForPeriod(interval, type: operationsType)
        var unsortedOperations: Dictionary<Date, [Operation]> = [:]
        for operation in operations {
            //брать дату только по дню
            let components = Calendar.current.dateComponents([.year, .month, .day], from: operation.date!)
            let operationDate = Calendar.current.date(from: components)!
            //если элемент уже есть, то добавляем в массив, если нет, то создаем новый
            if unsortedOperations[operationDate] != nil{
                unsortedOperations[operationDate]?.append(operation)
            }
            else{
                unsortedOperations[operationDate] = [operation]
            }
        }
        //заполняем сортированный массив
        var sortedOperations: [(date: Date, operations: [Operation])] = []
        for operation in unsortedOperations.sorted(by: {$0.key > $1.key}){
            sortedOperations.append((operation.key, operation.value))
        }
        currentOperations = sortedOperations
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let operationController = segue.destination as? OperationHandlerViewController{
            operationController.currentOperation = (sender as? Operation)
        }
    }
}

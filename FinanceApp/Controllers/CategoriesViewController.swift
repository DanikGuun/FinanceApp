//
//  CategoriesViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var сategoriesTypeSegmented: UISegmentedControl!
    private var activeType: Model.OperationType = .Expence
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appereances.applyMenuBorder(&menuBackground)
        categoriesCollection.dataSource = self
        categoriesCollection.delegate = self

    }
    
    @IBAction func onChangeType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            activeType = .Expence
        case 1:
            activeType = .Income
        default:
            activeType = .Expence
        }
        categoriesCollection.reloadData()
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.shared.getAllCategories(type: activeType).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        if Model.shared.getAllCategories(type: activeType).count > indexPath.item{
            let currentCategory = Model.shared.getAllCategories(type: activeType)[indexPath.item]
            cell.setup(currentCategory)
        }
        else{
            cell.setup(name: "Добавить", icon: UIImage(systemName: "plus.app")!, iconBackroundColor: .clear, iconColor: .systemBlue)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "categoryHandler", sender: nil)
    }
    
    // MARK: Segou
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(1)
    }
}

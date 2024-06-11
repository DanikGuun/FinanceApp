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
        return Model.shared.getAllCategories(type: activeType).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        let currentCategory = Model.shared.getAllCategories(type: activeType)[indexPath.item]
        cell.setup(currentCategory)
        return cell
    }
}

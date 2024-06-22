//
//  CategoryPickViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 22.06.2024.
//

import Foundation
import UIKit

class CategoryPickViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var categoryType: Model.OperationType! //чтобы брать нужные категории
    var parentOperationController: CategoriesPickParent!
    
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = Model.shared.getAllCategories(type: categoryType)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "operationCategoryPickCell", for: indexPath) as! CategoryCell
        cell.setup(categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = width * (141/118)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        parentOperationController.categoryPick(cell.category!)
        navigationController?.popViewController(animated: true)
    }
    
}

protocol CategoriesPickParent{
    func categoryPick(_ category: Category)
}

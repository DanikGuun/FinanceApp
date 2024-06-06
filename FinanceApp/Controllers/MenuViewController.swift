//
//  MenuViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 06.06.2024.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var menuButtonsCollection: UICollectionView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    let menuButtonsAttributes: [(name: String, systemName: String, segou: String)] = [
        ("Главная", "rublesign.arrow.circlepath", "operationsSegou"),
        ("Категории", "list.clipboard", "categoriesSegou")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appereances.applyMenuBorder(&menuBackgroundView)
        menuButtonsColectionSetup()
    }
    
    // MARK: - CollectionView
    
    func menuButtonsColectionSetup(){
        menuButtonsCollection.layer.cornerRadius = 10
        menuButtonsCollection.delegate = self
        menuButtonsCollection.dataSource = self
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuButtonsAttributes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let needSeparator = indexPath.row != menuButtonsAttributes.endIndex-1 //если последний, то не ставим разделитель
        let cell = menuButtonsCollection.dequeueReusableCell(withReuseIdentifier: "menuButtonCell", for: indexPath) as! MenuButtonViewCell
        cell.setup(menuButtonsAttributes[indexPath.row], separatorNeed: needSeparator)
         //расширяем collectionView
        
        constraintHeight.constant = cell.frame.size.height * CGFloat(menuButtonsAttributes.count)
        print(cell.frame.size.height * CGFloat(menuButtonsAttributes.count))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = menuButtonsCollection.cellForItem(at: indexPath) as! MenuButtonViewCell
        self.performSegue(withIdentifier: cell.segouID, sender: nil)
    }
}

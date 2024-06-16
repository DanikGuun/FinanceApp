//
//  MultiColorpickerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 16.06.2024.
//

import Foundation
import UIKit

class MultiColorpickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var colorsCollection: UICollectionView!
    @IBOutlet weak var menuBackground: UIView!
    
    var parentController: MultiColorpickerParent!
    let colors: [UIColor] = Model.shared.getAvailableColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorsCollection.dataSource = self
        colorsCollection.delegate = self
        Appereances.applyMenuBorder(&menuBackground)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "multiColorPicker", for: indexPath) as! MultiColorpickerCell
        cell.setup(color: colors[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MultiColorpickerCell
        parentController.colorPickedFromMultiMenu(color: cell.color)
        navigationController?.popViewController(animated: true)
    }
}

protocol MultiColorpickerParent{
    func colorPickedFromMultiMenu(color: UIColor)
}

//
//  IconpickerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 17.06.2024.
//

import Foundation
import UIKit

class IconpickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    
    var iconBackgroundColor: UIColor!
    var iconDictionary: Dictionary<IconManager.IconCategories, [String]>!
    var iconCategories: [IconManager.IconCategories] = []
    var parentView: IconpickerParent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconDictionary = Model.shared.getIconsDictionary()
        
        for icon in iconDictionary.keys{
            iconCategories.append(icon)
        }
        
        iconsCollectionView.delegate = self
        iconsCollectionView.dataSource = self
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        iconDictionary.keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconDictionary[iconCategories[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "iconType", for: indexPath) as! IconsHeaderView
        sectionHeader.setup(name: iconCategories[indexPath.section].rawValue)
        return sectionHeader
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconWithoutBackgroundCell
        let currentCategory = iconCategories[indexPath.section]
        let currentIconName = iconDictionary[currentCategory]![indexPath.row]
        cell.setup(icon: UIImage(systemName: currentIconName)!, iconBackgroundColor: iconBackgroundColor)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! IconWithoutBackgroundCell
        parentView.pickIconFromMenu(icon: Model.shared.getSFName(of: cell.iconImageView.image!))
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - collectionView.verticalScrollIndicatorInsets.left -  collectionView.horizontalScrollIndicatorInsets.right) / 4
        let height = width
        return CGSize(width: width, height: height)
    }
}

protocol IconpickerParent{
    func pickIconFromMenu(icon: String)
}

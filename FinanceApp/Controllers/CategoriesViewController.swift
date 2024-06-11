//
//  CategoriesViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 11.06.2024.
//

import Foundation
import UIKit

class CategoriesViewController: UIViewController{
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var сategoriesTypeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appereances.applyMenuBorder(&menuBackground)
    }
    
    @IBAction func onChangeType(_ sender: UISegmentedControl) {
    }
    
    // MARK: CollectionView
}

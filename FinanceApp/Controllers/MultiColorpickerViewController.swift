//
//  MultiColorpickerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 16.06.2024.
//

import Foundation
import UIKit

class MultiColorpickerViewController: UICollectionViewController{
    
    var parentController: MultiColorpickerParent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

protocol MultiColorpickerParent{
    func colorPickedFromMultiMenu(color: UIColor)
}

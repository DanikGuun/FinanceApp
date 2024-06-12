//
//  CategoryHandlerViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 12.06.2024.
//

import Foundation
import UIKit

class CategoryHandlerViewController: UIViewController{
    @IBOutlet weak var menuBackground: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Appereances.applyMenuBorder(&menuBackground)
    }
}

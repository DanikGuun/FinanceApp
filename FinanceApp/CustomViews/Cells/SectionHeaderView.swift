//
//  IconsHeaderView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 17.06.2024.
//

import Foundation
import UIKit

class SectionsHeaderView: UICollectionReusableView{
    
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    func setup(name: String){
        self.sectionNameLabel.text = name
    }
}

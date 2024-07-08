//
//  OperationStoryCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 08.07.2024.
//

import UIKit

class OperationStoryCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    var currentOperation: Operation!
    
    func setup(operation: Operation){
        Appereances.applyShadow(cellBackgroundView)
        cellBackgroundView.layer.cornerRadius = 12
        
        let category = Model.shared.getCategoryByUUID(operation.categoryID!)
        iconBackgroundView.backgroundColor = UIColor(cgColor: Model.shared.stringToColor(category!.color!))
        iconBackgroundView.layer.cornerRadius = 7
        
        iconImageView.tintColor = UIColor.systemBackground
        iconImageView.image = UIImage(systemName: (category?.icon)!)
        
        categoryNameLabel.text = category?.name
        amountLabel.text = Appereances.moneyFormat(operation.amount)
        notesLabel.text = operation.notes
    }
}

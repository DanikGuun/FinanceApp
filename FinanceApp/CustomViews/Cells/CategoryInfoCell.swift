//
//  CategoryInfoCellCollectionViewCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 07.07.2024.
//

import UIKit

class CategoryInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryAmountLabel: UILabel!
    @IBOutlet weak var categoryPercentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func initialize(){
        Appereances.applyShadow(cellBackgroundView)
        cellBackgroundView.layer.cornerRadius = 12
        iconBackgroundView.layer.cornerRadius = 8
    }
    
    func setup(iconBackgroundColor: UIColor, icon: String, categoryName: String, categoryAmount: Double, categoryPercent: Int){
        initialize()
        
        iconBackgroundView.backgroundColor = iconBackgroundColor
        iconImageView.image = UIImage(systemName: icon)
        categoryNameLabel.text = categoryName
        categoryAmountLabel.text = Appereances.moneyFormat(categoryAmount)
        categoryPercentLabel.text = "\(categoryPercent)%"
    }
    func setup(data: CategoryInfo){
        initialize()
        
        iconBackgroundView.backgroundColor = data.iconColor
        iconImageView.image = UIImage(systemName: data.icon)
        categoryNameLabel.text = data.name
        categoryAmountLabel.text = Appereances.moneyFormat(data.amount)
        categoryPercentLabel.text = "\(data.percent)%"
    }
}

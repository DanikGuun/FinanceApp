//
//  WeekCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 30.06.2024.
//

import UIKit

class WeekCell: UICollectionViewCell {
    
    private var background: UIView!
    var dateInterval: DateInterval
    
    required init?(coder: NSCoder) {
        dateInterval = DateInterval()
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        dateInterval = DateInterval()
        super.init(frame: frame)
    }
    
    func setup(dateInterval: DateInterval){
        self.dateInterval = dateInterval
        setupBackground()
    }
    
    //MARK: Setups
    private func setupBackground(){
        background = UIView()
        self.addSubview(background)
        background.backgroundColor = .cellBackround
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 7
        background.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
        background.layer.shadowRadius = 1
        
        background.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }
}

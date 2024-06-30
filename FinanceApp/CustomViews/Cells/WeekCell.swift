//
//  WeekCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 30.06.2024.
//

import UIKit

class WeekCell: UICollectionViewCell {
    
    private var background: UIView!
    var dateLabel: UILabel!
    
    var dateInterval: DateInterval
    
    required init?(coder: NSCoder) {
        dateInterval = DateInterval()
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        dateInterval = DateInterval()
        super.init(frame: frame)
        setupBackground()
        setupLabel()
    }
    
    func setup(dateInterval: DateInterval){
        self.dateInterval = dateInterval
        setText(dateInterval: dateInterval)
    }
    //MARK: Setups
    
    func setText(dateInterval: DateInterval){
        let startFormatted = dateInterval.start.formatted(.dateTime.day().month(.abbreviated).locale(Locale(identifier: "ru_RU")))
        let endFormatted = dateInterval.end.formatted(.dateTime.day().month(.abbreviated).locale(Locale(identifier: "ru_RU")))
        let text = "\(startFormatted) - \(endFormatted)".capitalized
        dateLabel.text = text
    }
    
    private func setupLabel(){
        dateLabel = UILabel()
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.adjustsFontSizeToFitWidth = true
        
        dateLabel.font = UIFont.systemFont(ofSize: background.frame.height, weight: .medium)
        dateLabel.textAlignment = .center
        
        dateLabel.topAnchor.constraint(equalTo: background.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
    }
    
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

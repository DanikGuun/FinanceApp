//
//  WeekCell.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 30.06.2024.
//

import UIKit

class DateIntervalCell: UICollectionViewCell {
    
    private var background: UIView!
    private var dateLabel: UILabel!
    private var format: DateFormatter
    private var period: Calendar.Component = .calendar
    
    var dateInterval: DateInterval
    
    required init?(coder: NSCoder) {
        format = DateFormatter()
        dateInterval = DateInterval()
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        dateInterval = DateInterval()
        format = DateFormatter()
        super.init(frame: frame)
        setupBackground()
        setupLabel()
    }
    
    func setup(dateInterval: DateInterval, format: DateFormatter, period: Calendar.Component){
        self.dateInterval = dateInterval
        self.period = period
        self.format = format
        format.locale = Locale(identifier: "ru_RU")
        setText(dateInterval: dateInterval)
    }
    
    override func select(_ sender: Any?) {
        dateLabel.textColor = .systemBlue
        background.backgroundColor = .selectedDateCell
    }
    func unselect(){
        dateLabel.textColor = .label
        background.backgroundColor = .cellBackround
        
    }
    //MARK: Setups
    
    func setText(dateInterval: DateInterval){
        var text = ""
        switch period {
        case .weekOfYear:
            let startFormatted = format.string(from: dateInterval.start)
            let endFormatted = format.string(from: dateInterval.end)
            text = "\(startFormatted) - \(endFormatted)".capitalized
        case .month: //для месяца
            let month = Calendar.current.component(.month, from: dateInterval.start)
            var ruCalendar = Calendar(identifier: .gregorian)
            ruCalendar.locale = Locale(identifier: "ru_RU")
            text = ruCalendar.standaloneMonthSymbols[month - 1].capitalized
        case .year:
            //а то года сбиваются
            let date = Calendar.current.date(byAdding: .month, value: -1, to: dateInterval.end)!
            text = format.string(from: date)
        default:
            text = ""
        }

        dateLabel.text = text
    }
    
    private func setupLabel(){
        dateLabel = UILabel()
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textColor = .label
        
        dateLabel.font = UIFont.systemFont(ofSize: background.frame.height, weight: .semibold)
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

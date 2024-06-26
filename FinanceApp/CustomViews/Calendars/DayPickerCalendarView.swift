//
//  DayPickerCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 26.06.2024.
//

import Foundation
import UIKit

class DayPickerCalendarView: UICalendarView, UICalendarViewDelegate, IntervalCalendar{
    
    var intervalDelegate: (any IntervalCalendarDelegate)!
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .blue
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintCalendar(dateLabel: UIView, chartBackground: UIView) {
        self.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        self.leadingAnchor.constraint(equalTo: chartBackground.leadingAnchor, constant: -10).isActive = true
        self.trailingAnchor.constraint(equalTo: chartBackground.trailingAnchor, constant: 10).isActive = true
        self.bottomAnchor.constraint(equalTo: chartBackground.bottomAnchor, constant: 180).isActive = true
    }
}

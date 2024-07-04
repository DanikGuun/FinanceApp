//
//  PeriodCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 04.07.2024.
//

import UIKit

class PeriodCalendarView: UICalendarView, IntervalCalendar {
    
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    
    init(){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.locale = Locale(identifier: "ru_RU")
        setupDates()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        
    }

    func setupDates(){
        var components = Calendar.current.dateComponents(DateManager.standartComponentSet, from: Date())
        components.day = 1
        components.month = 1
        components.year = 2000
        let startDate = Calendar.current.date(from: components)!
        self.availableDateRange = DateInterval(start: startDate, end: Date())
    }
}

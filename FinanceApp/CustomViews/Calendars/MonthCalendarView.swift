//
//  MonthCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 02.07.2024.
//

import Foundation
import UIKit

class MonthCalendarView: UIView, IntervalCalendar{
    
    var bottomConstraint: NSLayoutConstraint!
    var intervalDelegate: (any IntervalCalendarDelegate)!
    
    var activeDate: Date
    
    init(activeDate: Date){
        self.activeDate = activeDate
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        self.activeDate = Date()
        super.init(coder: coder)
    }
    
    func setup() {
        
    }
    
    
}

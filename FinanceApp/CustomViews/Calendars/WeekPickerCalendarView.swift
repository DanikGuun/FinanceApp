//
//  WeekCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 29.06.2024.
//

import Foundation
import UIKit

class WeekPickerCalendarView: UIView, IntervalCalendar{
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(activeDate: Date){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

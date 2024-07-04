//
//  PeriodCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 04.07.2024.
//

import UIKit

class PeriodCalendarView: UICalendarView, IntervalCalendar, UICalendarSelectionMultiDateDelegate {
    
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    
    init(){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.locale = Locale(identifier: "ru_RU")
        let selection = UICalendarSelectionMultiDate(delegate: self)
        self.selectionBehavior = selection
        setupDates()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: CalendarView
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        if selection.selectedDates.count == 2{
            let date1 = Calendar.current.date(from: selection.selectedDates[0])!
            let date2 = Calendar.current.date(from: selection.selectedDates[1])!
            
            intervalDelegate.onIntervalSelected(interval: DateInterval(start: min(date1, date2), end: max(date1, date2)))
        }
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        
    }
    
    //MARK: Setups
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

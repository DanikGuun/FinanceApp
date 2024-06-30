//
//  DayPickerCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 26.06.2024.
//

import Foundation
import UIKit

class DayPickerCalendarView: UICalendarView, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate, IntervalCalendar{
    
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    
    let standartComponentSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .weekday] //Стандартный набор компонентов для работы с датами
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(activeDate: Date) {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        self.selectionBehavior = selectionBehavior
        selectionBehavior.setSelected(calendar.dateComponents(standartComponentSet, from: activeDate), animated: true)
        
        self.locale = Locale(identifier: "ru_RU")
    }
    
    func setup() {
        setupDates()
    }
    
    //MARK: Calendar
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return dateComponents != nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let date = calendar.date(from: dateComponents!)!
        intervalDelegate.onIntervalSelected(interval: DateManager.dayInterval(date: date))
        
        removeCalendar()
    }
    
    //MARK: Setup
    
    private func setupDates(){
        var components = Calendar.current.dateComponents(standartComponentSet, from: Date())
        components.year = 2000
        components.month = 1
        components.day = 1
        self.availableDateRange = DateInterval(start: Calendar.current.date(from: components)!, end: Date())
    }
}

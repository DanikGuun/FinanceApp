//
//  operationsViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 19.06.2024.
//
import Foundation
import UIKit

class OperationsViewController: UIViewController, IntervalCalendarDelegate{
    
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var chartBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minusDateButton: UIButton!
    @IBOutlet weak var plusDateButton: UIButton!
    
    var activePeriod: Calendar.Component = .day
    var activeDate: Date = Date()
    let standartComponentSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .weekday] //Стандартный набор компонентов для работы с датами
    
    override func viewDidLoad() {
        Appereances.applyMenuBorder(menuBackgroundView)
        moneyLabel.text = "Счёт: \(Appereances.moneyFormat(16583))"
        
        Appereances.applyShadow(chartBackgroundView)
        chartBackgroundView.layer.cornerRadius = 10
    
        dateUpdate()
        //делаем нажатия на лэйбл с датой
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(dateLabelPressed))
        dateLabel.addGestureRecognizer(recogniser)
    }
    
    // MARK: Date Intervals Pickers
    @objc func dateLabelPressed(_ sender: UILabel){
        var calendar: IntervalCalendar
        
        switch activePeriod {
        case .day: calendar = DayPickerCalendarView()
        default: calendar = DayPickerCalendarView()
        }
        chartBackgroundView.addSubview(calendar)
        calendar.constraintCalendar(dateLabel: dateLabel, chartBackground: chartBackgroundView)
        calendar.intervalDelegate = self
    }
    func onIntervalSelected(interval: DateInterval) {
        
    }
    
    // MARK: Dates
    
    @IBAction func minusDate(_ sender: UIButton) {
        let date = Calendar.current.date(byAdding: activePeriod, value: -1, to: activeDate)
        dateUpdate(newDate: date)
        plusDateButton.isEnabled = true
    }
    @IBAction func plusDate(_ sender: UIButton) {
        let date = Calendar.current.date(byAdding: activePeriod, value: 1, to: activeDate)
        dateUpdate(newDate: date)
    }
    
    @IBAction func changePeriod(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0: activePeriod = .day
            case 1: activePeriod = .weekOfYear
            case 2: activePeriod = .month
            case 3: activePeriod = .year
            default: activePeriod = .calendar
        }
        
        dateUpdate()
    }
    
    ///Обновляет Текущую дату, включая отрисовку
    func dateUpdate(newDate: Date? = nil){
        if let newDate {activeDate = newDate}
        let interval = getDateInterval(start: activeDate, period: activePeriod)
        

        //вкл/выкл кнопки вправо дат
        
        if startOfDay(activeDate) >= startOfDay(Date()) {plusDateButton.isEnabled = false}
        else {plusDateButton.isEnabled = true}

        setDateLabelText(interval: interval, period: activePeriod)
    }
    
    func getDateInterval(start: Date, period: Calendar.Component) -> DateInterval{
        switch period {
            case .day: return dayInterval(date: start)
            case .weekOfYear: return weekInterval(date: start)
            case .month: return monthInterval(date: start)
            case .year: return yearInterval(date: start)
            default: return DateInterval()
        }
    }
    
    //счетчик интервалов для типов дат
    
    /**
    определяет промежуток для одного дня
     */
    func dayInterval(date: Date) -> DateInterval{
        return DateInterval(start: startOfDay(date), end: endOfDay(date))
    }
    /**
    определяет промежуток для одного дня
     - Cуть: берем начало и конец дня и через циклы ищем начало и конец недели
     */
    func weekInterval(date: Date) -> DateInterval{
        var startDate = startOfDay(date)
        var startWeekday: Int {Calendar.current.component(.weekday, from: startDate)}
        
        while startWeekday != Calendar.current.firstWeekday{
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
        }
        
        var endDate = endOfDay(date)
        var endWeekday: Int {Calendar.current.component(.weekday, from: endDate)}
        
        while endWeekday != Calendar.current.firstWeekday - 1{
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        }
        
        return DateInterval(start: startDate, end: endDate)
    }
    /**
    определяет промежуток для одного месяца
     - Cуть: берем начало дня, через компоненты меняем на первый день. Конец месяца через цикл листаем
     */
    func monthInterval(date: Date) -> DateInterval{
        var startComponents = Calendar.current.dateComponents(standartComponentSet, from: startOfDay(date))
        startComponents.day = 1
        let startDate = Calendar.current.date(from: startComponents)!
        
        var endDate = endOfDay(date)
        var endDateComponents: DateComponents {Calendar.current.dateComponents(standartComponentSet, from: endDate)}
        
        while startComponents.month == endDateComponents.month{
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        }
        endDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)! //сначала прибавляет, потом смотрит условие, надо вычесть один день
        
        return DateInterval(start: startDate, end: endDate)
    }
    /**
    определяет промежуток для одного месяца
     - Cуть: через компоненты ставим и всё
     */
    func yearInterval(date: Date) -> DateInterval{
        var startComponents = Calendar.current.dateComponents(standartComponentSet, from: startOfDay(date))
        startComponents.day = 1
        startComponents.month = 1
        let startDate = Calendar.current.date(from: startComponents)!
        
        var endComponents = Calendar.current.dateComponents(standartComponentSet, from: endOfDay(date))
        endComponents.day = 31
        endComponents.month = 12
        let endDate = Calendar.current.date(from: endComponents)!
        
        return DateInterval(start: startDate, end: endDate)
    }
    
    //начало дня
    func startOfDay(_ day: Date) -> Date{
        var start = Calendar.current.dateComponents(standartComponentSet, from: day)
        start.hour = 0
        start.minute = 0
        start.second = 0
        
        return Calendar.current.date(from: start)!
    }
    //конец дня
    func endOfDay(_ day: Date) -> Date{
        var end = Calendar.current.dateComponents(standartComponentSet, from: day)
        end.hour = 23
        end.minute = 59
        end.second = 59
        return Calendar.current.date(from: end)!
    }
    
    // MARK: Additions
    ///ставим дату на лейбле
    func setDateLabelText(interval: DateInterval, period: Calendar.Component){
        
        var dateString = ""
        switch period{
            
        case .day: dateString = interval.start.formatted(.dateTime.day(.twoDigits).month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            
        case .weekOfYear: dateString = interval.start.formatted(.dateTime.day(.twoDigits).month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            + " - " +
            interval.end.formatted(.dateTime.day(.twoDigits).month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            
        case .month: dateString = interval.start.formatted(.dateTime.month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            
        case .year: dateString = interval.start.formatted(.dateTime.year(.defaultDigits))
            
        default: dateString = ""
        }
        
        let attributedString = NSMutableAttributedString(string: dateString)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: dateString.count))
        let font = UIFont.systemFont(ofSize: dateLabel.frame.height, weight: .semibold)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: dateString.count))
        dateLabel.attributedText = attributedString
        dateLabel.adjustsFontSizeToFitWidth = true
    }
}

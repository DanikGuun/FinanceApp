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
        var insets: UIEdgeInsets
        
        switch activePeriod {
        case .day:
            calendar = DayPickerCalendarView(activeDate: activeDate)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 130, right: 10)
            
        case .weekOfYear:
            calendar = WeekPickerCalendarView(activeDate: activeDate)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 10, right: 10)
        default:
            calendar = DayPickerCalendarView(activeDate: activeDate)
            insets = UIEdgeInsets.zero
        }
        view.addSubview(calendar)
        calendar.constraintCalendar(chartBackground: chartBackgroundView, insets: insets)
        calendar.intervalDelegate = self
    }
    
    func onIntervalSelected(interval: DateInterval) {
        dateUpdate(newDate: interval.start) //сюда передаем просто день, а нужный период посчитает сам
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
        dateUpdate(newDate: Date())
    }
    
    func dateUpdate(newDate: Date? = nil){
    ///Обновляет Текущую дату, включая отрисовку
        if let newDate {activeDate = newDate}
        let interval = DateManager.getDateInterval(start: activeDate, period: activePeriod)
        
        //вкл/выкл кнопки вправо дат
        if DateManager.startOfDay(activeDate) >= DateManager.startOfDay(Date()) {plusDateButton.isEnabled = false}
        else {plusDateButton.isEnabled = true}

        setDateLabelText(interval: interval, period: activePeriod)
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

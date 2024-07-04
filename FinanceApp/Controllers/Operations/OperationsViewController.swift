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
    @IBOutlet weak var calendarBackground: UIView!
    
    var activePeriod: Calendar.Component = .day
    var activeInterval: DateInterval = DateInterval(start: DateManager.startOfDay(Date()), end: DateManager.endOfDay(Date()))
    var activeCalendar: IntervalCalendar!
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
        let background = UIView()
        view.addSubview(background)
        
        var calendar: IntervalCalendar
        var insets: UIEdgeInsets
        
        switch activePeriod {
        case .day:
            calendar = DayPickerCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 130, right: 10)
        case .weekOfYear:
            calendar = WeekPickerCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 10, right: 10)
        case .month:
            calendar = MonthCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 10, right: 10)
        case .year:
            calendar = YearCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 90, right: 10)
        default:
            calendar = PeriodCalendarView()
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 130, right: 10)
        }
        view.addSubview(calendar)
        calendar.constraintCalendar(chartBackground: chartBackgroundView, insets: insets)
        calendar.setup()
        calendar.intervalDelegate = self
        activeCalendar = calendar
        //фон для календаряz
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarBackground.alpha = 1
        })
    }
    
    func onIntervalSelected(interval: DateInterval) {
        dateUpdate(newInterval: interval) //сюда передаем просто день, а нужный период посчитает сам
        calendarHide()
    }
    
    @IBAction func calendarHide(){
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarBackground.alpha = 0
            self.activeCalendar.removeCalendar()
        })
    }
    
    // MARK: Dates
    
    @IBAction func minusDate(_ sender: UIButton) {
        //считаем новый день, от которого почсчитается интервал
        let newStartDate = Calendar.current.date(byAdding: activePeriod, value: -1, to: activeInterval.start)!
        dateUpdate(newInterval: DateManager.getDateInterval(start: newStartDate, period: activePeriod))
        plusDateButton.isEnabled = true
    }
    @IBAction func plusDate(_ sender: UIButton) {
        //считаем новый день, от которого почсчитается интервал
        let newStartDate = Calendar.current.date(byAdding: activePeriod, value: 1, to: activeInterval.start)!
        dateUpdate(newInterval: DateManager.getDateInterval(start: newStartDate, period: activePeriod))
    }
    
    @IBAction func changePeriod(_ sender: UISegmentedControl) {
        minusDateButton.isEnabled = true
        plusDateButton.isEnabled = true
        switch sender.selectedSegmentIndex{
        case 0: activePeriod = .day
        case 1: activePeriod = .weekOfYear
        case 2: activePeriod = .month
        case 3: activePeriod = .year
        default: do {
            self.activePeriod = .calendar
            self.dateLabelPressed(UILabel())
            minusDateButton.isEnabled = false
            plusDateButton.isEnabled = false
        }
        }
        dateUpdate(newInterval: DateManager.getDateInterval(start: Date(), period: activePeriod))
    }
    
    func dateUpdate(newInterval: DateInterval? = nil){
    ///Обновляет Текущую дату, включая отрисовку
        if let newInterval {activeInterval = newInterval}
        
        //вкл/выкл кнопки вправо дат, не включаем, если период
        if activePeriod != .calendar{
            if activeInterval.end >= DateManager.endOfDay(Date()) {plusDateButton.isEnabled = false}
            else {plusDateButton.isEnabled = true}
        }

        setDateLabelText(interval: activeInterval, period: activePeriod)
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
        dateString = dateString.localizedCapitalized
        
        let attributedString = NSMutableAttributedString(string: dateString)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: dateString.count))
        
        let font = UIFont.systemFont(ofSize: dateLabel.frame.height, weight: .semibold)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: dateString.count))
        dateLabel.attributedText = attributedString
        dateLabel.adjustsFontSizeToFitWidth = true
    }
}

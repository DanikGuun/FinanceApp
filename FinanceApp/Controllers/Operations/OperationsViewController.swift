//
//  operationsViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 19.06.2024.
//
import Foundation
import UIKit

class OperationsViewController: UIViewController{
    
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var chartBackgroundView: UIView!
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
    }
    
    // MARK: Dates
    
    @IBAction func minusDate(_ sender: UIButton) {
        dateUpdate(direction: .past)
        plusDateButton.isEnabled = true
    }
    @IBAction func plusDate(_ sender: UIButton) {
        dateUpdate(direction: .future)
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
    
    enum DateChangeDirrection: Int{
        case past = -1
        case no = 0
        case future = 1
    }
    
    ///Обновляет Текущую дату, включая отрисовку
    func dateUpdate(direction: DateChangeDirrection = .no){
        activeDate = Calendar.current.date(byAdding: activePeriod, value: direction.rawValue, to: activeDate)!
        let interval = getDateInterval(start: activeDate, period: activePeriod)
        print("\(interval.start.formatted(.dateTime)) - \(interval.end.formatted(.dateTime))")
        let activeDay = Calendar.current.component(.day, from: activeDate)
        let today = Calendar.current.component(.day, from: Date())
        
        if activeDay >= today {plusDateButton.isEnabled = false}
        else {plusDateButton.isEnabled = true}
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
}

//
//  DateManager.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 26.06.2024.
//

import Foundation

class DateManager{
    
    static let standartComponentSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .weekday] //Стандартный набор компонентов для работы с датами

    /**
    определяет промежуток для одного дня
     */
    static func dayInterval(date: Date) -> DateInterval{
        return DateInterval(start: startOfDay(date), end: endOfDay(date))
    }
    /**
    определяет промежуток для одного дня
     - Cуть: берем начало и конец дня и через циклы ищем начало и конец недели
     */
    static func weekInterval(date: Date) -> DateInterval{
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
    static func monthInterval(date: Date) -> DateInterval{
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
    static func yearInterval(date: Date) -> DateInterval{
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
    
    ///получает все недели для месяца, в котором находится день
    static func getWeeksForMonth(monthOf month: Date) -> [DateInterval]{
        //делаем дату на начало месяца
        var components = Calendar.current.dateComponents(standartComponentSet, from: month)
        components.day = 1
        var currentDate = Calendar.current.date(from: components)!
        var currentComponents: DateComponents { Calendar.current.dateComponents(standartComponentSet, from: currentDate)}
        
        var intervals: [DateInterval] = []
        
        //пока месяц равен изначальному, добавляем неделю
        while currentComponents.month == components.month && currentDate <= Date(){
            intervals.append(weekInterval(date: currentDate))
            currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
        }
        
        return intervals
    }
    
    ///Получает все месяцы до текущего
    static func getAvailableMonths(for month: Date) -> [Int]{
        if Calendar.current.component(.year, from: Date()) != Calendar.current.component(.year, from: month){
            return Array(0..<12)
        }
        let currentMonth = Calendar.current.component(.month, from: Date())
        return Array(0..<currentMonth)
    }
    
    //начало дня
    static func startOfDay(_ day: Date) -> Date{
        var start = Calendar.current.dateComponents(standartComponentSet, from: day)
        start.hour = 0
        start.minute = 0
        start.second = 0
        
        return Calendar.current.date(from: start)!
    }
    //конец дня
    static func endOfDay(_ day: Date) -> Date{
        var end = Calendar.current.dateComponents(standartComponentSet, from: day)
        end.hour = 23
        end.minute = 59
        end.second = 59
        return Calendar.current.date(from: end)!
    }
    
    static func getDateInterval(start: Date, period: Calendar.Component) -> DateInterval{
        switch period {
            case .day: return DateManager.dayInterval(date: start)
            case .weekOfYear: return DateManager.weekInterval(date: start)
            case .month: return DateManager.monthInterval(date: start)
            case .year: return DateManager.yearInterval(date: start)
            default: return DateInterval()
        }
    }
}

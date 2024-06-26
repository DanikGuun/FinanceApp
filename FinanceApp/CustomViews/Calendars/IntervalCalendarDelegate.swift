//
//  IntervalCalendarDelegate.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 26.06.2024.
//

import Foundation
import UIKit

protocol IntervalCalendarDelegate{ //для делегата календарей, просто чтобы сменить даты
    func onIntervalSelected(interval: DateInterval)
}
protocol IntervalCalendar: UIView{ //чтобы подогнать все календари под 1, ради удобства
    var intervalDelegate: IntervalCalendarDelegate! { get set }
    func constraintCalendar(dateLabel: UIView, chartBackground: UIView)//привязка календаря к родительскому бэку под дату
}

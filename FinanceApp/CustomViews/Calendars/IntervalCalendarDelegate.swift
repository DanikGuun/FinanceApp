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
    var bottomConstraint: NSLayoutConstraint! { get set }
}

extension IntervalCalendar{
    
    func constraintCalendar(chartBackground: UIView, insets: UIEdgeInsets){
        //делаем календарь прижатым к низу, после раздвигаем
        self.topAnchor.constraint(equalTo: chartBackground.topAnchor, constant: insets.top).isActive = true
        self.leadingAnchor.constraint(equalTo: chartBackground.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: chartBackground.trailingAnchor, constant: insets.right).isActive = true
        self.bottomConstraint = bottomAnchor.constraint(equalTo: chartBackground.bottomAnchor, constant: -chartBackground.frame.height)
        bottomConstraint.isActive = true
        
        self.superview!.layoutIfNeeded() //чтобы обновилось и стало прижатым к верху
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomConstraint.constant = insets.bottom
            self.superview!.layoutIfNeeded()
        })
        
        self.backgroundColor = UIColor(named: "ControllersBackground")
        self.layer.cornerRadius = 10
        
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor(named: "ShadowColor")!.cgColor
    }
    
    func removeCalendar(){
        //задаем констрейн высоты вместо нижней привязки и его к 0
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: self.frame.height)
        heightConstraint.isActive = true
        bottomConstraint.isActive = false
        UIView.animate(withDuration: 0.3, animations: {
            heightConstraint.constant = 0
            self.superview!.layoutIfNeeded()
        }, completion: {_ in self.removeFromSuperview()})
    }
}


//
//  PeriodPicker.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 25.06.2024.
//

import Foundation
import UIKit

class PeriodPicker: UICalendarView{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(){
        super.init(frame: CGRect.zero)
    }
}

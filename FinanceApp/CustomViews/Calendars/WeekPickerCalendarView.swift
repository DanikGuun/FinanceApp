//
//  WeekCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 29.06.2024.
//

import Foundation
import UIKit

class WeekPickerCalendarView: UIView, IntervalCalendar, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var yearAndMonthButton: UIButton!
    var datePicker: UIPickerView!
    
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    var activeDate: Date
    
    required init?(coder: NSCoder) {
        activeDate = Date()
        super.init(coder: coder)
    }
    
    init(activeDate: Date){
        self.activeDate = activeDate
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupDateButton()
        setupDatePicker()
    }
    
    //MARK: DatePicker
    func picker(_ isShow: Bool){
        let currentAlpha = isShow ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.datePicker.alpha = currentAlpha
        })
    }
    
    func setupDatePicker(){
        datePicker = UIPickerView()
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.alpha = 0
        self.addSubview(datePicker)
        
        datePicker.topAnchor.constraint(equalTo: yearAndMonthButton.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo:  self.bottomAnchor).isActive = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(component) - \(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    
    //MARK: YearAndMonthButton
    func setDateButtonText(_ date: Date){
        let str = date.formatted(.dateTime.month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU"))).localizedCapitalized
        
        let attributed = NSMutableAttributedString(string: str)
        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: str.count))
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        attributed.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.count))
        
        var conf = yearAndMonthButton.configuration
        conf?.attributedTitle = AttributedString(attributed)
        yearAndMonthButton.configuration = conf
    }
    
    func setupDateButton(){
        //кнопка делаем
        yearAndMonthButton = UIButton(configuration: .plain())
        yearAndMonthButton.changesSelectionAsPrimaryAction = true
        yearAndMonthButton.translatesAutoresizingMaskIntoConstraints = false
        yearAndMonthButton.contentHorizontalAlignment = .right
        yearAndMonthButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 14)
        self.addSubview(yearAndMonthButton)
        
        yearAndMonthButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        yearAndMonthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        yearAndMonthButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18).isActive = true
        
        //стрелка делаем
        let chevronImage = UIImageView()
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.image = UIImage(systemName: "chevron.forward")
        chevronImage.tintColor = .systemBlue
        chevronImage.contentMode = .scaleAspectFit
        self.addSubview(chevronImage)
        
        chevronImage.leadingAnchor.constraint(equalTo: yearAndMonthButton.trailingAnchor, constant: -14).isActive = true
        chevronImage.centerYAnchor.constraint(equalTo: yearAndMonthButton.centerYAnchor).isActive = true
        chevronImage.heightAnchor.constraint(equalToConstant: 14).isActive = true
        chevronImage.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
        yearAndMonthButton.configurationUpdateHandler = { button in
            
            //цвет текста
            button.tintColor = .clear
            let attributed = NSMutableAttributedString((button.configuration?.attributedTitle)!)
            let titleLength = button.titleLabel?.text?.count ?? 0
            let targetColor = button.isSelected ? UIColor.systemBlue : UIColor.black
            attributed.addAttribute(.foregroundColor, value: targetColor, range: NSRange(location: 0, length: titleLength))
            button.configuration?.attributedTitle = AttributedString(attributed)
            
            UIView.animate(withDuration: 0.3, animations: {
                chevronImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1/2 * (button.isSelected ? 1 : 0))
            })
        }
        
        yearAndMonthButton.addAction(UIAction(handler: { [self] _ in picker(yearAndMonthButton.isSelected)}), for: .touchUpInside)
        setDateButtonText(activeDate)
    }
}

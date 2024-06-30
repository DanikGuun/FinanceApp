//
//  WeekCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 29.06.2024.
//

import Foundation
import UIKit

class WeekPickerCalendarView: UIView, IntervalCalendar, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    
    var yearAndMonthButton: UIButton!
    var datePicker: UIPickerView!
    var datePickerBackground: UIView!
    var weekCollewctionView: UICollectionView!
    
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
        setupCollectionView()
        setupDatePicker()
    }
    
    //MARK: Week CollectionView
    func setupCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        weekCollewctionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.addSubview(weekCollewctionView)
        weekCollewctionView.translatesAutoresizingMaskIntoConstraints = false
        weekCollewctionView.delegate = self
        weekCollewctionView.dataSource = self
        weekCollewctionView.register(WeekCell.self, forCellWithReuseIdentifier: "weekCell")
        weekCollewctionView.backgroundColor = .clear
        
        weekCollewctionView.topAnchor.constraint(equalTo: yearAndMonthButton.bottomAnchor, constant: 10).isActive = true
        weekCollewctionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        weekCollewctionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        weekCollewctionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DateManager.getWeeksForMonth(monthOf: activeDate).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekCell
        cell.setup(dateInterval: DateManager.getWeeksForMonth(monthOf: activeDate)[indexPath.row])
        return cell
    }
    //MARK: DatePicker
    func picker(_ isShow: Bool){
        let currentAlpha = isShow ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.datePicker.alpha = currentAlpha
            self.datePickerBackground.alpha = currentAlpha
        })
    }
    
    func setupDatePicker(){
        datePicker = UIPickerView()
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.alpha = 0
        datePicker.backgroundColor = self.backgroundColor
        self.addSubview(datePicker)
        
        datePicker.topAnchor.constraint(equalTo: yearAndMonthButton.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo:  self.bottomAnchor).isActive = true
        
        //выбор даты по умолчанию
        let year = Calendar.current.component(.year, from: activeDate)
        datePicker.selectRow(year - 2000, inComponent: 1, animated: true)
        let month = Calendar.current.component(.month, from: activeDate)
        datePicker.selectRow(month - 1, inComponent: 0, animated: true)
        
        //настройка фона
        datePickerBackground = UIView()
        self.addSubview(datePickerBackground)
        datePickerBackground.translatesAutoresizingMaskIntoConstraints = false
        datePickerBackground.layer.cornerRadius = 50
        datePickerBackground.backgroundColor = .controllersBackground
        datePickerBackground.alpha = 0
        
        datePickerBackground.topAnchor.constraint(equalTo: datePicker.topAnchor).isActive = true
        datePickerBackground.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
        datePickerBackground.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor).isActive = true
        datePickerBackground.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor).isActive = true
        
        self.bringSubviewToFront(datePicker)//чтобы пикер был поверх фона
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let year = Calendar.current.component(.year, from: activeDate)
        
        if component == 0 {return 12}
        return year - 1999 //года
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            //элемент с месяцами
            var rusCalendar = Calendar(identifier: .gregorian)
            rusCalendar.locale = Locale(identifier: "ru_RU")
            return rusCalendar.standaloneMonthSymbols[row].capitalized
        }
        else{
            //года
            return "\(2000 + row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var currenDateComponents = Calendar.current.dateComponents(DateManager.standartComponentSet, from: activeDate)
        currenDateComponents.month = pickerView.selectedRow(inComponent: 0) + 1
        currenDateComponents.year = pickerView.selectedRow(inComponent: 1) + 2000
        
        let nowYear = Calendar.current.component(.year, from: Date())
        let availableMonthsNow = DateManager.getAvailableMonths(for: Date())
        //если забежали вперед по месяцам в текущем году, то откат
        if nowYear == currenDateComponents.year! && currenDateComponents.month! > availableMonthsNow.count + 1{
            pickerView.selectRow(availableMonthsNow.count - 1, inComponent: 0, animated: true)
            currenDateComponents.month = availableMonthsNow.count
        }
        activeDate = Calendar.current.date(from: currenDateComponents)!
        setDateButtonText(activeDate)

    }
    
    
    
    //MARK: YearAndMonthButton
    func setDateButtonText(_ date: Date){
        let str = date.formatted(.dateTime.month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU"))).localizedCapitalized
        
        //берем текущий title
        let buttonAttributed = NSAttributedString((yearAndMonthButton.configuration?.attributedTitle)!)
        let attributed = NSMutableAttributedString(attributedString: buttonAttributed)
        
        //меняем текст
        attributed.replaceCharacters(in: NSRange(location: 0, length: attributed.length), with: str)
        //шрифт
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        yearAndMonthButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        self.addSubview(yearAndMonthButton)
        
        yearAndMonthButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        yearAndMonthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        yearAndMonthButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18).isActive = true
        
        //делаем attributed для кнопки, чтобы при первом изменении не выкинул nil
        yearAndMonthButton.configuration?.attributedTitle = AttributedString()
        
        //стрелка делаем
        let chevronImage = UIImageView()
        chevronImage.image = UIImage(systemName: "chevron.forward")!.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.tintColor = .systemBlue
        chevronImage.contentMode = .scaleAspectFit
        self.addSubview(chevronImage)
        
        chevronImage.leadingAnchor.constraint(equalTo: yearAndMonthButton.trailingAnchor, constant: -16).isActive = true
        chevronImage.centerYAnchor.constraint(equalTo: yearAndMonthButton.centerYAnchor).isActive = true
        chevronImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        chevronImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
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
        //действие
        yearAndMonthButton.addAction(UIAction(handler: { [self] _ in picker(yearAndMonthButton.isSelected)}), for: .touchUpInside)
        setDateButtonText(activeDate)
    }
}

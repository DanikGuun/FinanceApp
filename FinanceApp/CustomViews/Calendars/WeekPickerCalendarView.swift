//
//  WeekCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 29.06.2024.
//

import Foundation
import UIKit

class WeekPickerCalendarView: UIView, IntervalCalendar, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var yearButton: UIButton!
    var datePicker: UIPickerView!
    var weekCollectionView: UICollectionView!
    var leftRightButtons: LeftRightButtons!
    let cellFormat = DateFormatter()
    
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    var activeDate: Date
    let initialDate: Date
    
    required init?(coder: NSCoder) {
        self.activeDate = Date()
        self.initialDate = Date()
        super.init(coder: coder)
    }
    
    init(activeDate: Date){
        self.activeDate = activeDate
        self.initialDate = activeDate
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(){
        cellFormat.dateFormat = "d MMMM"
        
        setupPlusMinusButtons()
        setupDateButton()
        setupCollectionView()
        setupDatePicker()
        updateDate(activeDate)
    }
    
    //MARK: Week CollectionView
    func setupCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        weekCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.addSubview(weekCollectionView)
        weekCollectionView.translatesAutoresizingMaskIntoConstraints = false
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        weekCollectionView.register(DateIntervalCell.self, forCellWithReuseIdentifier: "weekCell")
        weekCollectionView.backgroundColor = .clear
        
        weekCollectionView.topAnchor.constraint(equalTo: yearButton.bottomAnchor, constant: 10).isActive = true
        weekCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        weekCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        weekCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DateManager.getWeeksForMonth(monthOf: activeDate).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! DateIntervalCell
        let interval = DateManager.getWeeksForMonth(monthOf: activeDate)[indexPath.row]
        cell.setup(dateInterval: interval, format: cellFormat, period: .weekOfYear)
        if interval.contains(initialDate) {cell.select(nil)}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unselectCells()
        let cell = collectionView.cellForItem(at: indexPath) as! DateIntervalCell
        cell.select(nil)
        intervalDelegate.onIntervalSelected(interval: cell.dateInterval)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = collectionView.frame.height / 3
        return CGSize(width: width, height: height)
    }
    
    func unselectCells(){
        for cell in weekCollectionView.visibleCells as! [DateIntervalCell]{
            cell.unselect()
        }
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
        datePicker.backgroundColor = self.backgroundColor
        datePicker.layer.cornerRadius = self.layer.cornerRadius
        self.addSubview(datePicker)
        
        datePicker.topAnchor.constraint(equalTo: yearButton.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo:  self.bottomAnchor).isActive = true
        
        //выбор даты по умолчанию
        let year = Calendar.current.component(.year, from: activeDate)
        datePicker.selectRow(year - 2000, inComponent: 1, animated: true)
        let month = Calendar.current.component(.month, from: activeDate)
        datePicker.selectRow(month - 1, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let year = Calendar.current.component(.year, from: Date())
        
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
        updateDate(activeDate)
    }
    
    //MARK: Plus Minus Button
    func setupPlusMinusButtons(){
        let leftHandler = { [self] (direction: UIAction) in
            let newDate = Calendar.current.date(byAdding: .month, value: -1, to: activeDate)!
            if Calendar.current.component(.year, from: newDate) >= 2000{
                activeDate = newDate
                updateDate(activeDate)
            }
            
        }
        let rightHandler = { [self] (direction: UIAction) in
            let newDate = Calendar.current.date(byAdding: .month, value: 1, to: activeDate)!
            if newDate <= Date(){
                activeDate = newDate
                updateDate(activeDate)
            }
        }
        leftRightButtons = LeftRightButtons(leftHandler: leftHandler, rightHandler: rightHandler)
        self.addSubview(leftRightButtons)
        leftRightButtons.constraintToUpRight(to: self)
    }
    
    //MARK: YearButton
    func setDateButtonText(_ date: Date){
        
        
        let str = date.formatted(.dateTime.month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU"))).localizedCapitalized
        
        //берем текущий title
        let buttonAttributed = NSAttributedString((yearButton.configuration?.attributedTitle)!)
        let attributed = NSMutableAttributedString(attributedString: buttonAttributed)
        
        //меняем текст
        attributed.replaceCharacters(in: NSRange(location: 0, length: attributed.length), with: str)
        //шрифт
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        attributed.addAttribute(.font, value: font, range: NSRange(location: 0, length: str.count))
        
        var conf = yearButton.configuration
        conf?.attributedTitle = AttributedString(attributed)
        yearButton.configuration = conf
    }
    
    func setupDateButton(){
        //кнопка делаем
        yearButton = UIButton(configuration: .plain())
        yearButton.changesSelectionAsPrimaryAction = true
        yearButton.translatesAutoresizingMaskIntoConstraints = false
        yearButton.contentHorizontalAlignment = .right
        yearButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        self.addSubview(yearButton)
        
        yearButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        yearButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        yearButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18).isActive = true
        
        //делаем attributed для кнопки, чтобы при первом изменении не выкинул nil
        yearButton.configuration?.attributedTitle = AttributedString()
        
        //стрелка делаем
        let chevronImage = UIImageView()
        chevronImage.image = UIImage(systemName: "chevron.forward")!.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.tintColor = .systemBlue
        chevronImage.contentMode = .scaleAspectFit
        self.addSubview(chevronImage)
        
        chevronImage.leadingAnchor.constraint(equalTo: yearButton.trailingAnchor, constant: -16).isActive = true
        chevronImage.centerYAnchor.constraint(equalTo: yearButton.centerYAnchor).isActive = true
        chevronImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        chevronImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        yearButton.configurationUpdateHandler = { button in
            
            //цвет текста
            button.tintColor = .clear
            let attributed = NSMutableAttributedString((button.configuration?.attributedTitle)!)
            let titleLength = button.titleLabel?.text?.count ?? 0
            let targetColor = button.isSelected ? UIColor.systemBlue : UIColor.label
            attributed.addAttribute(.foregroundColor, value: targetColor, range: NSRange(location: 0, length: titleLength))
            button.configuration?.attributedTitle = AttributedString(attributed)
            
            UIView.animate(withDuration: 0.3, animations: {
                chevronImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1/2 * (button.isSelected ? 1 : 0))
            })
        }
        //действие
        yearButton.addAction(UIAction(handler: { [self] _ in picker(yearButton.isSelected)}), for: .touchUpInside)
        setDateButtonText(activeDate)
    }
    
    //MARK: Date
    func updateDate(_ date: Date){
        setDateButtonText(date)
        unselectCells()
        weekCollectionView.reloadData()
        //проверка ограничений для кнопок
        leftRightButtons.setLeftButtonEnabled(true)
        leftRightButtons.setRightButtonEnabled(true)
        if Calendar.current.component(.year, from: activeDate) <= 2000 && Calendar.current.component(.month, from: activeDate) <= 1{
            leftRightButtons.setLeftButtonEnabled(false)
        }
        if DateManager.getDateInterval(start: activeDate, period: .month).end >= Date(){
            leftRightButtons.setRightButtonEnabled(false)
        }
        
        datePicker.selectRow(Calendar.current.component(.month, from: activeDate) - 1, inComponent: 0, animated: true)
        datePicker.selectRow(Calendar.current.component(.year, from: activeDate) - 2000, inComponent: 1, animated: true)
    }
}

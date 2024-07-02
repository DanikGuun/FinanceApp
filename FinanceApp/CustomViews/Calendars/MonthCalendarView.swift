//
//  MonthCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 02.07.2024.
//

import Foundation
import UIKit

class MonthCalendarView: UIView, IntervalCalendar, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var yearButton: UIButton!
    var yearPicker: UIPickerView!
    var monthCollection: UICollectionView!
    var bottomConstraint: NSLayoutConstraint!
    var intervalDelegate: (any IntervalCalendarDelegate)!
    let cellFormat = DateFormatter()
    
    var activeDate: Date
    let initDate: Date
    
    init(activeDate: Date){
        self.activeDate = activeDate
        self.initDate = activeDate
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        self.activeDate = Date()
        self.initDate = Date()
        super.init(coder: coder)
    }
    
    func setup() {
        
        cellFormat.dateFormat = "MMMM"
        cellFormat.isLenient = false
        
        setupDateButton()
        setDateButtonText(activeDate)
        monthCollectionSetup()
        setupYearPicker()
    }
    
    //MARK: Month Collection
    func monthCollectionSetup(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        monthCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.addSubview(monthCollection)
        monthCollection .translatesAutoresizingMaskIntoConstraints = false
        monthCollection.backgroundColor = .clear
        monthCollection.delegate = self
        monthCollection.dataSource = self
        
        monthCollection.topAnchor.constraint(equalTo: yearButton.bottomAnchor).isActive = true
        monthCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        monthCollection.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        monthCollection.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        monthCollection.register(DateIntervalCell.self, forCellWithReuseIdentifier: "MonthCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DateManager.getAvailableMonths(for: activeDate).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! DateIntervalCell

        var components = Calendar.current.dateComponents(DateManager.standartComponentSet, from: activeDate)
        components.month = indexPath.row + 1
        let date = Calendar.current.date(from: components)!
        
        let interval = DateManager.monthInterval(date: date)
        if interval.contains(initDate){cell.select(nil)}
        
        cell.setup(dateInterval: interval, format: cellFormat, period: .month)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = collectionView.frame.height / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateIntervalCell
        unSelectCells()
        cell.select(nil)
        intervalDelegate.onIntervalSelected(interval: cell.dateInterval)
    }
    
    func unSelectCells(){
        for cell in monthCollection.visibleCells as! [DateIntervalCell]{
            cell.unselect()
        }
    }
    
    
    //MARK: YearPicker
    func picker(isShow: Bool){
        let alpha: CGFloat = isShow ? 1 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.yearPicker.alpha = alpha
        })
    }
    
    func setupYearPicker(){
        yearPicker = UIPickerView(frame: .zero)
        self.addSubview(yearPicker)
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        yearPicker.backgroundColor = self.backgroundColor
        yearPicker.layer.cornerRadius = self.layer.cornerRadius
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.alpha = 0
        
        yearPicker.topAnchor.constraint(equalTo: yearButton.bottomAnchor).isActive = true
        yearPicker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        yearPicker.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        yearPicker.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        let year = Calendar.current.component(.year, from: activeDate)
        yearPicker.selectRow(year - 2000, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Calendar.current.component(.year, from: Date()) - 1999
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(2000 + row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var components = Calendar.current.dateComponents(DateManager.standartComponentSet, from: activeDate)
        components.year = 2000 + pickerView.selectedRow(inComponent: 0)
        activeDate = Calendar.current.date(from: components)!
        setDateButtonText(activeDate)
        unSelectCells()
        monthCollection.reloadData()
    }
    
    
    //MARK: YearButton
    func setDateButtonText(_ date: Date){
        let str = date.formatted(.dateTime.year(.defaultDigits).locale(Locale(identifier: "ru_RU"))).localizedCapitalized
        
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
            let targetColor = button.isSelected ? UIColor.systemBlue : UIColor.black
            attributed.addAttribute(.foregroundColor, value: targetColor, range: NSRange(location: 0, length: titleLength))
            button.configuration?.attributedTitle = AttributedString(attributed)
            
            UIView.animate(withDuration: 0.3, animations: {
                chevronImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1/2 * (button.isSelected ? 1 : 0))
            })
        }
        //действие
        setDateButtonText(activeDate)
        yearButton.addAction(UIAction(handler: { [self]_ in picker(isShow: yearButton.isSelected)}), for: .touchUpInside)
    }
}

//
//  YearCalendarView.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 02.07.2024.
//

import Foundation
import UIKit

class YearCalendarView: UIView, IntervalCalendar, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var yearCollectionView: UICollectionView!
    var intervalDelegate: (any IntervalCalendarDelegate)!
    var bottomConstraint: NSLayoutConstraint!
    
    var activeDate: Date
    let format: DateFormatter
    
    init(activeDate: Date){
        self.activeDate = activeDate
        self.format = DateFormatter()
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        self.activeDate = Date()
        self.format = DateFormatter()
        super.init(coder: coder)
    }
    
    func setup() {
        format.dateFormat = "YYYY"
        yearCollectionSetup()
        
        //небольшая задержка на создание ячеек и листаем к выделенной
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { _ in
            let year = Calendar.current.component(.year, from: self.activeDate) - 2000
            let lastIndex = IndexPath(row: year, section: 0)
            self.yearCollectionView.scrollToItem(at: lastIndex, at: .centeredVertically, animated: true)
        })
    }
    
    //MARK: Collection
    func yearCollectionSetup(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        yearCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.addSubview(yearCollectionView)
        yearCollectionView.layer.cornerRadius = self.layer.cornerRadius
        yearCollectionView .translatesAutoresizingMaskIntoConstraints = false
        yearCollectionView.backgroundColor = .clear
        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
     
        yearCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        yearCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        yearCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        yearCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    
        yearCollectionView.register(DateIntervalCell.self, forCellWithReuseIdentifier: "YearCell")
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let year = Calendar.current.component(.year, from: Date())
        return year - 1999
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearCell", for: indexPath) as! DateIntervalCell
        let year = 2000 + indexPath.row
        let currentYear = Calendar.current.component(.year, from: activeDate)
        var components = Calendar.current.dateComponents(DateManager.standartComponentSet, from: activeDate)
        components.year = year
        let yearDate = Calendar.current.date(from: components)!

        cell.setup(dateInterval: DateManager.yearInterval(date: yearDate), format: format, period: .year)
        if year == currentYear {cell.select(nil)}
        else{cell.unselect()}

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateIntervalCell
        unselectCells()
        cell.select(nil)
        intervalDelegate.onIntervalSelected(interval: cell.dateInterval)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = width * 0.5
        return CGSize(width: width, height: height)
    }
    
    func unselectCells(){
        for cell in yearCollectionView.visibleCells as! [DateIntervalCell]{
            cell.unselect()
        }
    }
}

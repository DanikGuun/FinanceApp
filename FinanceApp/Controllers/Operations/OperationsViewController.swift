//
//  operationsViewController.swift
//  FinanceApp
//
//  Created by Данила Бондарь on 19.06.2024.
//
import Foundation
import UIKit
import PieChartUIKit

class OperationsViewController: UIViewController, IntervalCalendarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var operationTypeSegmented: UISegmentedControl!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var chartBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minusDateButton: UIButton!
    @IBOutlet weak var plusDateButton: UIButton!
    @IBOutlet weak var calendarBackground: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var operationsPieChart: PieChartView!
    var centerCircle: UIImageView!
    var todayBalance: UILabel!
    var currentCollectionViewData: [CategoryInfo] = []
    
    var activePeriod: Calendar.Component = .day
    var activeInterval: DateInterval = DateInterval(start: DateManager.startOfDay(Date()), end: DateManager.endOfDay(Date()))
    var activeCalendar: IntervalCalendar!
    let standartComponentSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .weekday] //Стандартный набор компонентов для работы с датами
    var activeOperationType: Model.OperationType {
        if operationTypeSegmented.selectedSegmentIndex == 0 {return .Expence}
        return .Income
    }
    
    override func viewDidLoad() {
        setupOperationsPieChart()
        setupTodayBalance()
        
        Appereances.applyMenuBorder(menuBackgroundView)
        
        Appereances.applyShadow(chartBackgroundView)
        chartBackgroundView.layer.cornerRadius = 10
    
        dateUpdate()
        //делаем нажатия на лэйбл с датой
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(dateLabelPressed))
        dateLabel.addGestureRecognizer(recogniser)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    // MARK: Date Intervals Pickers
    @objc func dateLabelPressed(_ sender: UILabel){
        let background = UIView()
        view.addSubview(background)
        
        var calendar: IntervalCalendar
        var insets: UIEdgeInsets
        
        switch activePeriod {
        case .day:
            calendar = DayPickerCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 130, right: 10)
        case .weekOfYear:
            calendar = WeekPickerCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 10, right: 10)
        case .month:
            calendar = MonthCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 10, right: 10)
        case .year:
            calendar = YearCalendarView(activeDate: activeInterval.start)
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 90, right: 10)
        default:
            calendar = PeriodCalendarView()
            insets = UIEdgeInsets(top: 0, left: -10, bottom: 130, right: 10)
        }
        view.addSubview(calendar)
        calendar.constraintCalendar(chartBackground: chartBackgroundView, insets: insets)
        calendar.setup()
        calendar.intervalDelegate = self
        activeCalendar = calendar
        //фон для календаряz
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarBackground.alpha = 1
        })
    }
    
    func onIntervalSelected(interval: DateInterval) {
        dateUpdate(newInterval: interval) //сюда передаем просто день, а нужный период посчитает сам
        calendarHide()
    }
    
    @IBAction func calendarHide(){
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarBackground.alpha = 0
            self.activeCalendar.removeCalendar()
        })
    }
    
    // MARK: Dates
    
    @IBAction func minusDate(_ sender: UIButton) {
        //считаем новый день, от которого почсчитается интервал
        let newStartDate = Calendar.current.date(byAdding: activePeriod, value: -1, to: activeInterval.start)!
        dateUpdate(newInterval: DateManager.getDateInterval(start: newStartDate, period: activePeriod))
        plusDateButton.isEnabled = true
    }
    @IBAction func plusDate(_ sender: UIButton) {
        //считаем новый день, от которого почсчитается интервал
        let newStartDate = Calendar.current.date(byAdding: activePeriod, value: 1, to: activeInterval.start)!
        dateUpdate(newInterval: DateManager.getDateInterval(start: newStartDate, period: activePeriod))
    }
    
    @IBAction func changePeriod(_ sender: UISegmentedControl) {
        minusDateButton.isEnabled = true
        plusDateButton.isEnabled = true
        switch sender.selectedSegmentIndex{
        case 0: activePeriod = .day
        case 1: activePeriod = .weekOfYear
        case 2: activePeriod = .month
        case 3: activePeriod = .year
        default: do {
            self.activePeriod = .calendar
            self.dateLabelPressed(UILabel())
            minusDateButton.isEnabled = false
            plusDateButton.isEnabled = false
        }
        }
        dateUpdate(newInterval: DateManager.getDateInterval(start: Date(), period: activePeriod))
    }
    
    func dateUpdate(newInterval: DateInterval? = nil){
    ///Обновляет Текущую дату, включая отрисовку
        if let newInterval {activeInterval = newInterval}
        
        //вкл/выкл кнопки вправо дат, не включаем, если период
        if activePeriod != .calendar{
            if activeInterval.end >= DateManager.endOfDay(Date()) {
                plusDateButton.isEnabled = false}
            else {plusDateButton.isEnabled = true}
        }

        setDateLabelText(interval: activeInterval, period: activePeriod)
        updateData()
    }
    
    //MARK: Operations
    func updateData(){
        let operations = Model.shared.getCategoriedOperatioinsForPeriod(period: activeInterval, type: activeOperationType)
        
        var chartData: [ChartSegment] = []
        var categoryData: [CategoryInfo] = []
        let todaySumm = Model.shared.getOperationsForPeriod(activeInterval, type: activeOperationType).reduce(0.0, {$0 + $1.amount})
        
        for categoryID in operations.keys{
            
            let category = Model.shared.getCategoryByUUID(categoryID)!
            let categoryColor = UIColor(cgColor: Model.shared.stringToColor((category.color)!))
            let amount: Double = (operations[categoryID]?.reduce(0.0, {$0 + $1.amount}))!
            
            chartData.append(ChartSegment(value: amount, color: categoryColor))
            let categoryInfo = CategoryInfo(category: category,
                                            percent: Int((amount/todaySumm*100).rounded()),
                                            amount: amount)
            categoryData.append(categoryInfo)
        }
        self.currentCollectionViewData = categoryData
        setChartData(chartData)
        updateBalance()
        updateTodatBalance(sum: todaySumm)
        categoryCollectionView.reloadData()
    }

    //MARK: PieChart
    func setupOperationsPieChart(){
        operationsPieChart = PieChartView(frame: CGRect.zero)
        operationsPieChart.shouldShowPercentageLabel = false
        operationsPieChart.shouldHighlightPieOnTouch = false
        operationsPieChart.segmentInnerCornerRadius = 5
        operationsPieChart.offset = 1
        operationsPieChart.segmentOuterCornerRadius = 0
        //констрейны
        chartBackgroundView.addSubview(operationsPieChart)
        operationsPieChart.translatesAutoresizingMaskIntoConstraints = false
        operationsPieChart.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        operationsPieChart.bottomAnchor.constraint(equalTo: chartBackgroundView.bottomAnchor, constant: -17).isActive = true
        operationsPieChart.centerXAnchor.constraint(equalTo: chartBackgroundView.centerXAnchor).isActive = true
        operationsPieChart.widthAnchor.constraint(equalTo: operationsPieChart.heightAnchor, multiplier: 1.0).isActive = true
        
        chartBackgroundView.layoutIfNeeded()

        //белый кружок посередине
        centerCircle = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        chartBackgroundView.addSubview(centerCircle)
        centerCircle.translatesAutoresizingMaskIntoConstraints = false
        centerCircle.image = UIImage(systemName: "circle.fill")
        centerCircle.tintColor = chartBackgroundView.backgroundColor
        
        let inset = CGFloat(17)
        centerCircle.centerXAnchor.constraint(equalTo: operationsPieChart.centerXAnchor).isActive = true
        centerCircle.centerYAnchor.constraint(equalTo: operationsPieChart.centerYAnchor).isActive = true
        centerCircle.heightAnchor.constraint(equalToConstant: operationsPieChart.frame.height - inset*2).isActive = true
        centerCircle.widthAnchor.constraint(equalToConstant: operationsPieChart.frame.width - inset*2).isActive = true
    }

    func setChartData(_ data: [ChartSegment]){
        //если не пустой
        if data.count > 0{
            operationsPieChart.pieFilledPercentages = Array(repeating: 1, count: data.count)
            operationsPieChart.segments = data.map {$0.value}
            operationsPieChart.pieGradientColors = data.map {[$0.color, $0.color]}
            //если меньше 3 элементов, чарт не может работать адекватно, поэтому добавляем пустышки
            if data.count < 3{
                operationsPieChart.pieFilledPercentages = operationsPieChart.pieFilledPercentages + [0,0,0]
                operationsPieChart.segments = operationsPieChart.segments + [0,0,0]
                operationsPieChart.pieGradientColors = operationsPieChart.pieGradientColors + [[UIColor.clear, UIColor.clear], [UIColor.clear, UIColor.clear], [UIColor.clear, UIColor.clear]]
            }
        }
        //если пустой, заливаес серым
        else{
            operationsPieChart.pieFilledPercentages = [1,0,0]
            operationsPieChart.segments = [1,0,0]
            operationsPieChart.pieGradientColors = [[UIColor.emptyChart, UIColor.emptyChart], [UIColor.clear, UIColor.clear], [UIColor.clear, UIColor.clear]]
        }
    }
    
    @IBAction func chartSwiped(_ sender: UISwipeGestureRecognizer) {
        if activePeriod != .calendar{
            if sender.direction == .left && activeInterval.end <= DateManager.startOfDay(Date()) {plusDate(plusDateButton)}
            else if sender.direction == .right {minusDate(minusDateButton)}
        }
    }
    
    //MARK: TodayBalance
    func setupTodayBalance(){
        todayBalance = UILabel(frame: CGRect.zero)
        todayBalance.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(todayBalance)
        
        todayBalance.textAlignment = .center
        todayBalance.adjustsFontSizeToFitWidth = true
        todayBalance.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        //тут использвуем гайд, чтобы привязать к концу кружка, а не всей вью
        todayBalance.topAnchor.constraint(equalTo: centerCircle.readableContentGuide.topAnchor, constant: 3).isActive = true
        todayBalance.bottomAnchor.constraint(equalTo: centerCircle.readableContentGuide.bottomAnchor, constant: -3).isActive = true
        todayBalance.leadingAnchor.constraint(equalTo: centerCircle.readableContentGuide.leadingAnchor, constant: 3).isActive = true
        todayBalance.trailingAnchor.constraint(equalTo: centerCircle.readableContentGuide.trailingAnchor, constant: -3).isActive = true
    }
    
    func updateTodatBalance(sum: Double){
        todayBalance.text = Appereances.moneyFormat(sum)
    }

    //MARK: Categories Info Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentCollectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryInfoCell", for: indexPath) as! CategoryInfoCell
        cell.setup(data: currentCollectionViewData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height / 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: Additions
    ///ставим дату на лейбле
    func setDateLabelText(interval: DateInterval, period: Calendar.Component){
        
        var dateString = ""
        switch period{
            
        case .day: dateString = interval.start.formatted(.dateTime.day(.twoDigits).month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            
        case .weekOfYear, .calendar: dateString = interval.start.formatted(.dateTime.day(.twoDigits).month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            + " - " +
            interval.end.formatted(.dateTime.day(.twoDigits).month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            
        case .month: dateString = interval.start.formatted(.dateTime.month(.wide).year(.defaultDigits).locale(Locale(identifier: "ru_RU")))
            
        case .year: dateString = interval.start.formatted(.dateTime.year(.defaultDigits))
            
        default: dateString = ""
        }
        dateString = dateString.localizedCapitalized
        
        let attributedString = NSMutableAttributedString(string: dateString)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: dateString.count))
        
        let font = UIFont.systemFont(ofSize: dateLabel.frame.height, weight: .semibold)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: dateString.count))
        dateLabel.attributedText = attributedString
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    @IBAction func operationTypeChanged() {
        updateData()
    }
    //обновляет баланс
    func updateBalance(){
        var total = 0.0
        for operation in Model.shared.getAllOperations(){
            if operation.type == .Expence {total -= operation.amount}
            else {total += operation.amount}
        }
        moneyLabel.text = "Счёт: \(Appereances.moneyFormat(total))"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let operationHandler = segue.destination as? OperationHandlerViewController{
            operationHandler.startOperationType = self.operationTypeSegmented.selectedSegmentIndex
            if activePeriod == .day{
                operationHandler.startDate = activeInterval.start
            }
        }
    }
}
struct ChartSegment{
    let value: CGFloat
    let color: UIColor
}
struct CategoryInfo{
    let category: Category
    let percent: Int
    let amount: Double
}

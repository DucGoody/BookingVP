//
//  PopupSelectTimeViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JTAppleCalendar

class PopupSelectTimeViewController: BaseViewController {
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    
    var onSelectDate: ((Date) ->Void)?
    private var dateSelected: Date = Date()
    private var todayDate: Date = Date()
    
    private let formatter = DateFormatter()
    private let numberOfRows = 6
    private var timer = Timer()
    
    init(dateSelected: Date) {
        super.init(nibName: "PopupSelectTimeViewController", bundle: nil)
        self.dateSelected = dateSelected
    }
    
    required init?(coder: NSCoder) {
         super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavigationBar = false
        self.initUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         UIView.animate(withDuration: 0.2) {
             self.dateView.transform = CGAffineTransform.identity
         }
     }
    
    func initUI() {
        self.dateView.layer.cornerRadius = 5
        self.dateView.clipsToBounds = true
        self.dateView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        
        formatter.dateFormat = "MMMM YYYY"
        self.monthLabel.text = formatter.string(from: self.dateSelected)
        formatter.dateFormat = "dd/MM/yyyy"
        self.todayDate = formatter.date(from: formatter.string(from: Date())) ?? Date()
        
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.configureCalendarView()
        
        self.initAction()
    }
    
    func initAction() {
        self.cancelButton.rx.tap.asDriver()
        .throttle(.milliseconds(1000))
        .drive(onNext: { (_) in
            self.dismiss(animated: false, completion: nil)
        }).disposed(by: disponseBag)
        
        self.doneButton.rx.tap.asDriver()
        .throttle(.milliseconds(1000))
        .drive(onNext: { (_) in
            self.onSelectDate?(self.dateSelected)
            self.dismiss(animated: false, completion: nil)
        }).disposed(by: disponseBag)
    }
    
    func configureCalendarView(){
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.register(UINib(nibName: "CalendarSectionHeaderView", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                              withReuseIdentifier: "CalendarSectionHeaderView")
        self.calendarView.register(UINib.init(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        self.calendarView.scrollToDate(self.dateSelected,animateScroll: false)
        self.calendarView.selectDates([self.dateSelected])
    }
    
    // Configure the cell
    func configureCell(cell: JTAppleCell?, cellState: CellState, date: Date? = nil, isSelect: Bool = false) {
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        currentCell.lbDay.backgroundColor = UIColor.clear
        currentCell.lbDay.text = cellState.text
        configureSelectedStateFor(cell: currentCell, cellState: cellState)
        configureTextColorFor(cell: currentCell, cellState: cellState)
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        currentCell.isHidden = cellHidden
    }
    
    // Configure text colors
    func configureTextColorFor(cell: JTAppleCell?, cellState: CellState){
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        if cellState.isSelected{
            currentCell.lbDay.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth && cellState.date > Date()  {
                currentCell.lbDay.textColor = UIColor.black
            }else{
                currentCell.lbDay.textColor = UIColor.gray
            }
        }
    }
    
    //Configure text image selected
     func configureSelectedStateFor(cell: JTAppleCell?, cellState: CellState){
            guard let currentCell = cell as? CalendarCell else {
                return
            }
        
            if cellState.isSelected{
                currentCell.ivSelect.isHidden = false
                currentCell.viewSelect.isHidden = false
            }else{
                currentCell.ivSelect.isHidden = true
                currentCell.viewSelect.isHidden = true
            }
        }

    @IBAction func actionClickBackground(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}


extension PopupSelectTimeViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let dateF = DateFormatter()
        formatter.dateFormat = "dd MM yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        dateF.dateFormat = "yy"
        dateF.timeZone = Calendar.current.timeZone
        dateF.locale = Calendar.current.locale
        calendar.scrollingMode = .stopAtEachSection
        
        let startDate = Date()
        let dateFInt = Int(dateF.string(from: startDate))
        
        let endDate = formatter.date(from: "31 12 \((dateFInt ?? 30) + 1)")!
        
                let parameters = ConfigurationParameters(startDate: startDate,
                                endDate: endDate,
                                numberOfRows: numberOfRows,
                                calendar: Calendar.current,
                                generateInDates: .forAllMonths,
                                generateOutDates: .tillEndOfRow,
                                firstDayOfWeek: .monday,
                                hasStrictBoundaries: true)
        return parameters
    }
}

extension PopupSelectTimeViewController: JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if self.todayDate.compare(date) == .orderedDescending {
            return
        }
        self.dateSelected = date
        configureCell(cell: cell, cellState: cellState, date: date, isSelect: true)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()
            formatter.dateFormat = "MMMM YYYY"
        let date = range.start
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.monthLabel.text = formatter.string(from: date)
        })
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarSectionHeaderView", for: indexPath)
        
       
        (header as! CalendarSectionHeaderView).title.text = formatter.string(from: date)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 0.000001)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: self.dateView.frame.size.width, height: 100)
    }

}

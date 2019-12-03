//
//  BookingVC.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/26/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class BookingVC: BaseViewController {
    //ui
    @IBOutlet weak var btnSendRequire: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let listCell: [String] = ["EnterInfoCell","EnterInfoCell","EnterInfoCell","SelectTimeCell","RoomTypeCell","TotalPriceCell"]
    var booking: BookingHotel!
    var dateDefault: Date!
    
    var listIndexCell: [TypeCell] = [.enterInfoCell,.enterInfoCell,.enterInfoCell,.dateCell,.roomTypeCell,.totalPriceCell]
    var dataSource = RxTableViewSectionedReloadDataSource<EntitySectionBooking>(
        configureCell: { (_,_,_,_) in
            fatalError()
    })
    let itemsPopup = [
        EntityPopup.init(tag: 0, name: "Thường"),
        EntityPopup.init(tag: 1, name: "VIP"),
        EntityPopup.init(tag: 2, name: "VVIP")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateDefault = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        self.booking = BookingHotel.init(startDate: dateDefault, endDate: dateDefault, roomQuantity: 1, roomType: RoomTypeEnum.normal.rawValue)
        self.initUI()
    }
    
    func initUI() {
        self.isShowNavigationBar = true
        self.navigationItem.title = "Đặt phòng"
        
        self.btnSendRequire.layer.cornerRadius = 8
        self.btnSendRequire.rx.tap.subscribe(onNext: { (_) in
            
        }).disposed(by: disponseBag)
        self.initTableView()
    }
    
    func initTableView() {
        self.tableView.separatorColor = UIColor.clear
        for item in listCell {
            self.tableView.register(UINib.init(nibName: item, bundle: nil), forCellReuseIdentifier: item)
        }
        
        self.dataSource = RxTableViewSectionedReloadDataSource<EntitySectionBooking>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            
            if indexPath.row == 4 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: self.listCell[indexPath.row]) as? RoomTypeCell {
                    cell.setDataType(entitySelected: self.booking.roomType)
                    cell.onSelect = {
                        self.onSelectPopup()
                    }
                    return cell
                }
            } else if indexPath.row == 3 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: self.listCell[indexPath.row]) as? SelectTimeCell {
                    cell.binData(startTime: self.booking.startDate ?? self.dateDefault, endTime: self.booking.endDate ?? self.dateDefault)
                    cell.onSelectTime = { [unowned self] value in
                        self.onSelectTime(value)
                    }
                    return cell
                }
            } else if indexPath.row == 5 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: self.listCell[indexPath.row]) as? TotalPriceCell {
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: self.listCell[indexPath.row]) as? EnterInfoCell {
                    cell.setUIByIndex(row: indexPath.row)
                    cell.onReturnTextField = { [unowned self] row in
                        self.onShouldReturn(row: row)
                    }
                    
                    cell.onChangeTextField = { [unowned self] string, row in
                        self.onChangeTextField(text: string,row: row)
                    }
                    if indexPath.row == 0 {
                        cell.tfInput.text = self.booking.bookingName
                    } else if indexPath.row == 1 {
                        cell.tfInput.text = self.booking.bookingPhone
                    } else if indexPath.row == 2 {
                        cell.tfInput.text = "\(self.booking.roomQuantity)"
                    }
                    return cell
                }
            }
            return UITableViewCell()
        })
        
        let sections = [EntitySectionBooking.init(items: [EntityItemSectionBooking.init(typeCell: .enterInfoCell),EntityItemSectionBooking.init(typeCell: .enterInfoCell),EntityItemSectionBooking.init(typeCell: .dateCell), EntityItemSectionBooking.init(typeCell: .roomTypeCell), EntityItemSectionBooking.init(typeCell: .countRoomCell), EntityItemSectionBooking.init(typeCell: .totalPriceCell)])]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disponseBag)
    }
    
    func onShouldReturn(row: Int) {
        if row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.listCell[row + 1]) as? EnterInfoCell {
                cell.tfInput.becomeFirstResponder()
            }
        }
    }
    
    func onChangeTextField(text: String?,row: Int) {
        if row == 0 {
            self.booking.bookingName = text
        } else if row == 1 {
            self.booking.bookingPhone = text
        } else {
            self.booking.roomQuantity = Int(text ?? "") ?? 1
        }
    }
    
    func onSelectPopup() {
        let indexPath = IndexPath.init(row: 4, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath), let cell2 = cell as? RoomTypeCell else { return }
        let vc = PopupFilterVC.init(viewInput: cell2, datas: itemsPopup, tagItemSelected: self.booking.roomType, isRoomType: true)
        vc.modalPresentationStyle = .overCurrentContext
        vc.onSelectItemFilter = { [unowned self] (value) in
            self.booking.roomType = value.tag
            self.tableView.reloadData()
        }
        self.present(vc, animated: false)
        self.view.endEditing(true)
    }
    
    func onSelectTime(_ isStart: Bool) {
        var startDate: Date = self.dateDefault
        var endDate: Date = self.dateDefault
        if let startDateBooking = self.booking.startDate {
            startDate = startDateBooking
        }
        
        if let endDateBooking = self.booking.endDate {
            endDate = endDateBooking
        }
        
        let dateInput: Date = isStart ? startDate : endDate
        let vc = PopupSelectTimeVC.init(dateSelect: dateInput)
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.onSelectDate = { [unowned self] date in
            if isStart {
                self.booking.startDate = date
            } else {
                self.booking.endDate = date
            }
            self.tableView.reloadData()
        }
        self.present(vc, animated: false, completion: nil)
        self.view.endEditing(true)
    }
    
    func validateInfo() -> Bool {
        return true
    }
}

enum TypeCell: Int {
    case none = -1
    case enterInfoCell = 0
    case countRoomCell = 1
    case roomTypeCell = 3
    case dateCell = 2
    case totalPriceCell = 4
}

class EntityItemSectionBooking {
    var typeCell: TypeCell = .none
    
    init(typeCell: TypeCell) {
        self.typeCell = typeCell
    }
}

struct EntitySectionBooking {
    var items: [Item]
}

extension EntitySectionBooking: SectionModelType {
    init(original: EntitySectionBooking, items: [EntityItemSectionBooking]) {
        self = original
        self.items = items
    }
    
    typealias Item = EntityItemSectionBooking
}

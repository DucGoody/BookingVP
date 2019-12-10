//
//  BookingViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/10/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class BookingViewController: BaseViewController {
    //room type
    @IBOutlet weak var roomTypeView: UIView!
    @IBOutlet weak var roomTypeTextField: UITextField!
    @IBOutlet weak var roomTypeButton: UIButton!
    
    //total price
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var priceRoomLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var priceRoomByTypeLabel: UILabel!
    
    // enter info
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var quantityRoomTextField: UITextField!
    
    // date
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    
    //send
    @IBOutlet weak var sendButton: UIButton!
    
    private var booking: BookingHotel!
    private var dateDefault: Date!
    private var formatter: DateFormatter!
    var hotel: Hotel!
    private var viewModel: BookingViewModel!
    var homeViewController: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatter = DateFormatter()
        self.formatter.dateFormat = "dd/MM/yyyy"
        
        self.viewModel = BookingViewModel()
        
        self.dateDefault = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        self.booking = BookingHotel.init(startDate: dateDefault, endDate: dateDefault, roomQuantity: 1, roomType: RoomTypeEnum.vip.rawValue)
        
        self.initUI()
        self.updateUI()
        
    }
    
    func initUI() {
        self.isShowNavigationBar = true
        self.navigationItem.title = "Đặt phòng"
        //room type
        self.roomTypeView.layer.cornerRadius = 5
        self.roomTypeView.layer.borderWidth = 0.5
        self.roomTypeView.layer.borderColor = UIColor.gray.cgColor
        
        //total price
        self.contactLabel.text = "Chúng tôi sẽ liên hệ lại với bạn để xác nhận việc đặt phòng.\nVui lòng điền đúng thông tin!"
        
        //enter info

        //date
        self.endDateView.layer.cornerRadius = 5
        self.endDateView.layer.borderWidth = 0.5
        self.endDateView.layer.borderColor = UIColor.gray.cgColor
        self.startDateView.layer.cornerRadius = 5
        self.startDateView.layer.borderWidth = 0.5
        self.startDateView.layer.borderColor = UIColor.gray.cgColor
        
        //send
        self.sendButton.layer.cornerRadius = 5
        
        self.initAction()
    }
    
    func initAction() {
        self.roomTypeButton.rx.tap.asDriver().throttle(.milliseconds(500)).drive(onNext: { (_) in
            self.view.endEditing(true)
            self.showPopupSelectRoomType()
        }).disposed(by: disponseBag)
        
        self.startDateButton.rx.tap.asDriver().throttle(.milliseconds(500)).drive(onNext: { (_) in
            self.view.endEditing(true)
            self.showPopupSelectTime(true)
        }).disposed(by: disponseBag)
        
        self.endDateButton.rx.tap.asDriver().throttle(.milliseconds(500)).drive(onNext: { (_) in
            self.view.endEditing(true)
            self.showPopupSelectTime(false)
        }).disposed(by: disponseBag)
        
        self.sendButton.rx.tap.asDriver().throttle(.milliseconds(500)).drive(onNext: { (_) in
            self.view.endEditing(true)
            self.showLoadingView(true)
            self.sendBooking()
        }).disposed(by: disponseBag)
        
        self.quantityRoomTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func sendBooking() {
        Observable.of(self.booking).bind(to: self.viewModel.paramAvailabeRooms).disposed(by: disponseBag)
        self.availabeRooms()
    }
    
    func availabeRooms() {
        self.viewModel.resultAvailabeRooms.asObservable().bind { (result) in
            guard let result = result else {self.showLoadingView(false); return}
            if result == 0 {// error
                self.showLoadingView(false)
                self.showToast(message: "Số phòng không đủ", isSuccess: false)
            } else {
                Observable.of(self.booking).bind(to: self.viewModel.paramBooking).disposed(by: self.disponseBag)
                self.bookingHotel()
            }
        }.disposed(by: disponseBag)
    }
    
    func bookingHotel() {
        self.viewModel.resultBooking.asObservable().bind { (response) in
            self.showLoadingView(false)
            guard let res = response else {return}
            if res.code == 0 { // success
                self.showAlert()
            } else { // error
                self.showToast(message: "Có lỗi xảy ra. Vui lòng thử lại", isSuccess: false)
            }
        }.disposed(by: disponseBag)
    }
    
    func showAlert() {
        let alert = UIAlertController.init(title: "Thành công", message: "Đặt phòng thành công. Chúng tôi sẽ sớm liên hệ với bạn để xác nhận lại", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Đóng", style: .cancel, handler: { (action) in
            if let home = self.homeViewController {
                self.navigationController?.popToViewController(home, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField === self.phoneTextField {
            self.booking.bookingPhone = self.phoneTextField.text ?? ""
        } else if textField === self.nameTextField {
            self.booking.bookingName = self.nameTextField.text ?? ""
        } else if textField === self.quantityRoomTextField {
            self.booking.roomQuantity = Int(self.quantityRoomTextField.text ?? "") ?? 0
            self.updateUI()
        }
    }
    
    func showPopupSelectRoomType() {
        let items = [
            EntityPopup.init(tag: 0, name: "VIP"),
            EntityPopup.init(tag: 1, name: "VVIP"),
            EntityPopup.init(tag: 2, name: "Deluxe Vip")
        ]
        let popupFilterViewController = PopupFilterViewController.init(inputTodoView: self.roomTypeView, datas: items, tagItemSelected: self.booking.roomType, isRoomType: true)
        popupFilterViewController.modalPresentationStyle = .overCurrentContext
        popupFilterViewController.onSelectedItem = { [unowned self] (value) in
            self.booking.roomType = value.tag
            self.updateUI()
        }
        self.present(popupFilterViewController, animated: false)
        self.view.endEditing(true)
    }
    
    
    func showPopupSelectTime(_ isStart: Bool) {
        let dateInput: Date = isStart ? self.booking.startDate : self.booking.endDate
        let popupSelectTimeViewController = PopupSelectTimeViewController.init(dateSelected: dateInput)
        popupSelectTimeViewController.modalPresentationStyle = .overCurrentContext
        popupSelectTimeViewController.onSelectDate = { [unowned self] date in
            if isStart {
                self.booking.startDate = date
            } else {
                self.booking.endDate = date
            }
            self.updateUI()
        }
        self.present(popupSelectTimeViewController, animated: false, completion: nil)
        self.view.endEditing(true)
    }
    
    func updateUI() {
        self.startDateTextField.text = self.formatter.string(from: self.booking.startDate)
        self.endDateTextField.text = self.formatter.string(from: self.booking.endDate)
        if self.booking.roomQuantity > 0 {
            self.quantityRoomTextField.text = "\(self.booking.roomQuantity)"
        }
        
        self.updatePrice()
    }
    
    func updatePrice() {
        if self.booking.roomType == RoomTypeEnum.deluxevip.rawValue {
            self.roomTypeTextField.text = RoomTypeEnum.deluxevip.name
            self.priceRoomByTypeLabel.text = "Phòng \(RoomTypeEnum.deluxevip.name): \(self.formatCurrency(priceString: self.hotel.deluxeVipprice))/ngày"
            self.priceRoomLabel.text = self.formatCurrency(priceString: self.hotel.deluxeVipprice)
        } else if self.booking.roomType == RoomTypeEnum.vvip.rawValue {
            self.roomTypeTextField.text = RoomTypeEnum.vvip.name
            self.priceRoomByTypeLabel.text = "Phòng \(RoomTypeEnum.vvip.name): \(self.formatCurrency(priceString: self.hotel.vVipprice))/ngày"
            self.priceRoomLabel.text = self.formatCurrency(priceString: self.hotel.vVipprice)
        } else {
            self.roomTypeTextField.text = RoomTypeEnum.vip.name
            self.priceRoomByTypeLabel.text = "Phòng \(RoomTypeEnum.vip.name): \(self.formatCurrency(priceString: self.hotel.vipprice))/ngày"
            self.priceRoomLabel.text = self.formatCurrency(priceString: self.hotel.vipprice)
        }
        
        self.getTotalPrice()
    }
    
    func getTotalPrice() {
        let countDay = Calendar.current.dateComponents([.day], from: self.booking.startDate, to: self.booking.endDate).day ?? 1
        self.daysLabel.text = "\(countDay + 1) ngày"
        
        var priceString = self.priceRoomLabel.text?.replacingOccurrences(of: ".", with: "")
        priceString = priceString?.replacingOccurrences(of: " ₫", with: "")
        
        let price = Double(priceString ?? "1000000") ?? 0
        let totalPrice = (price * Double((countDay + 1))) * Double(self.booking.roomQuantity)
        self.totalPriceLabel.text = self.convertDoubleToString(totalPrice)
    }
    
    func formatCurrency(priceString: String) -> String {
        if priceString.lowercased().contains(" vnđ") {
            return priceString.lowercased().replacingOccurrences(of: " vnđ", with: " ₫")
        } else if priceString.lowercased().contains("vnđ") {
            return priceString.lowercased().replacingOccurrences(of: "vnđ", with: " ₫")
        } else {
            return priceString
        }
    }
    
    func convertDoubleToString(_ price: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var resultString = formatter.string(from: NSNumber.init(value: price)) ?? "0"
        resultString = resultString.replacingOccurrences(of: ",", with: ".")
        return "\(resultString) ₫"
    }
}

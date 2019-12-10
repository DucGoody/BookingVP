//
//  BookingViewModel.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BookingViewModel: NSObject {
    var paramBooking = BehaviorRelay<BookingHotel?>.init(value: nil)
    var paramAvailabeRooms = BehaviorRelay<BookingHotel?>.init(value: nil)
    var resultBooking = BehaviorRelay<ResponseBooking?>.init(value: nil)
    var resultAvailabeRooms = BehaviorRelay<Int?>.init(value: nil)

    var paramGetBookingbyPhone = BehaviorRelay<String>(value: "")
    var resultGetBookingbyPhone = BehaviorRelay<[BookingHotel]?>.init(value: nil)

    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        availabeRooms()
        bookingHotel()
    }
    
    func bookingHotel() {
        self.paramBooking.asObservable().subscribe(onNext: { (booking) in
            guard let booking = booking else {return}
            ServiceController().booking(bookingInfo: booking) { (response) in
                self.resultBooking.accept(response)
            }
        }).disposed(by: disposeBag)
    }
    
    func getBookingByPhone() {
        self.paramGetBookingbyPhone.asObservable().subscribe(onNext: { (phone) in
            ServiceController().getBookingByPhone(phone: phone) { (bookings) in
                self.resultGetBookingbyPhone.accept(bookings ?? [])
            }
        }).disposed(by: disposeBag)
    }
    
    func availabeRooms() {
        self.paramAvailabeRooms.asObservable().subscribe(onNext: { (booking) in
            guard let booking = booking else {return}
            ServiceController().availabeRooms(booking: booking) { (result) in
                self.resultAvailabeRooms.accept(result)
            }
        }).disposed(by: disposeBag)
    }
    
}

//
//  HotelViewModel.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HotelViewModel {
    var keyFilter = BehaviorRelay<Int>.init(value: 0)
    var resultGetHotelsByCity = BehaviorRelay<[Hotel]>(value: [])
    var onLoadDataDone: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    /*
     get hotels by city
     created by Hoàng Văn Đức
     */
    func getHotelsByCity() {
        self.keyFilter.asObservable().subscribe(onNext: { (keyFilter) in
            ServiceController().getHotelsByCity(keyFilter: keyFilter) { (hotels) in
                guard let hotels = hotels else {return}
                self.resultGetHotelsByCity.accept(hotels)
                self.onLoadDataDone?()
            }
        }).disposed(by: disposeBag)
    }
}

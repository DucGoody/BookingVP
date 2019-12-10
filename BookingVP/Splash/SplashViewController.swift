//
//  SplashViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SplashViewController: BaseViewController {
    private var cityViewModel: CityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavigationBar = false
        self.cityViewModel = CityViewModel()
        self.cityViewModel.getCities()
        self.getCities()
    }
    
    /*
     get data xong chuyển tới màn hình home
     created by Hoàng Văn Đức
     */
    func getCities() {
        if !self.isCheckInternet() {
            return
        }
        
        self.cityViewModel.resultGetCities.asObservable().bind { (cities) in
            guard let cities = cities else {return}
            self.gotoHomeVC(cities: cities)
        }.disposed(by: disponseBag)
    }
    
    //chuyển tới màn hình home sau khi load xong các thành phố
    func gotoHomeVC(cities: [City]?) {
        if let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController { // cast về home thành công
            homeViewController.cities = cities ?? []
            self.navigationController?.pushViewController(homeViewController, animated: false)
        }
//        else {
//            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as UIViewController
//            self.navigationController?.pushViewController(viewController, animated: false)
//        }
    }
}

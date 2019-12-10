//
//  HomeViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: BaseViewController {
    //Control
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //contraint
    @IBOutlet weak var heightStatusViewConstraint: NSLayoutConstraint!
    
    //
    private let hotelCell = "HotelCell"
    private var itemFilterSelected: EntityPopup!
    var cities: [City] = []
    private var itemsPopup: [EntityPopup] = []
    private var hotelViewModel: HotelViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavigationBar = false
        
        self.initUI()
        self.initDataPopup()
        
        self.hotelViewModel = HotelViewModel()
        self.hotelViewModel.getHotelsByCity()
        self.loadHotels()
        self.binData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.heightStatusViewConstraint.constant = self.getHeightSafeAreaTop()
    }
    
    /*
     init UI
     created by Hoàng Văn Đức
     */
    func initUI() {
        //tableView
        tableView.register(UINib.init(nibName: hotelCell, bundle: nil), forCellReuseIdentifier: hotelCell)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 16, right: 0)
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        
        //
        cityView.layer.cornerRadius = 5
        cityView.layer.borderColor = UIColor.lightGray.cgColor
        cityView.layer.borderWidth = 0.5
        cityLabel.textColor = UIColor.textMain
    }
    
    /*
     hiển thị thông tin user
     created by Hoàng Văn Đức
     */
//    @IBAction func actionShowInfoUser(_ sender: Any) {
//         
//     }
     
    /*
     chuyển tới màn hình thông báo
     created by Hoàng Văn Đức
     */
     @IBAction func actionGotoNotifications(_ sender: Any) {
         let vc = NotificationsViewController()
         self.navigationController?.pushViewController(vc, animated: true)
     }
    
    /*
     chọn filter hotel by city
     created by Hoàng Văn Đức
     */
     @IBAction func actionShowPopupFilter(_ sender: Any) {
        let vc = PopupFilterViewController.init(inputTodoView: cityView, datas: itemsPopup, tagItemSelected: itemFilterSelected.tag)
        vc.modalPresentationStyle = .overCurrentContext
        vc.onSelectedItem = { [unowned self] (value) in
            // xử lý chọn địa điểm xong
            self.itemFilterSelected = value
            self.cityLabel.text = value.name
            self.loadHotels()
        }
        self.present(vc, animated: false)
     }
    
    /*
     load hotels
     created by Hoàng Văn Đức
     */
    func loadHotels() {
        self.showLoadingView(true)
        Observable.of(self.itemFilterSelected.tag).bind(to: self.hotelViewModel.keyFilter).disposed(by: disponseBag)
    }
    
    /*
     bin data tableView
     created by Hoàng Văn Đức
     */
    func binData() {
        self.hotelViewModel.resultGetHotelsByCity.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: hotelCell, cellType: HotelCell.self)) { index,hotel,cell in
            cell.binData(hotel: hotel)
        }.disposed(by: disponseBag)
        
        self.hotelViewModel.onLoadDataDone = {
            self.showLoadingView(false)
        }
        
        //action select item tableView
        self.tableView.rx
        .modelSelected(Hotel.self)
        .subscribe(onNext:  { value in
            self.gotoDetailViewController(hotel: value)
        })
        .disposed(by: disponseBag)
    }
    
    //action chọn chuyển tới chi tiết hotel
    func gotoDetailViewController(hotel: Hotel) {
        let vc = DetailViewController()
        vc.hotel = hotel
        vc.homeViewController = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     init data popup
     created by Hoàng Văn Đức
     */
    func initDataPopup() {
        if cities.count > 0 { // nếu địa điểm lấy từ service có item
            for item in cities {
                let item = EntityPopup.init(tag: item.CityID, name: item.CityName)
                itemsPopup.append(item)
            }
            let item = EntityPopup.init(tag: 0, name: "Tất cả địa điểm")
            itemsPopup.insert(item, at: 0)
        }
        
        // TH service lỗi không trả về dữ liệu thì fech data
        if itemsPopup.count <= 0 {
            itemsPopup = [
                EntityPopup.init(tag: 0, name: "Tất cả địa điểm"),
                EntityPopup.init(tag: 1, name: "Hồ Chí Minh"),
                EntityPopup.init(tag: 2, name: "Hà Nội"),
                EntityPopup.init(tag: 3, name: "Quảng Ninh"),
                EntityPopup.init(tag: 4, name: "Vũng Tàu"),
                EntityPopup.init(tag: 5, name: "Phú Quốc"),
                EntityPopup.init(tag: 6, name: "Hưng Yên")
            ]
        }
        
        // mặc định giá trị chọn là item[0]
        itemFilterSelected = itemsPopup[0]
    }
}

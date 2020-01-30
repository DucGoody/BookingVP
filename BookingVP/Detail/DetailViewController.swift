//
//  DetailViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class DetailViewController: BaseViewController {
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    private let headerDetailView = "HeaderDetailView"
    private let emptyTableViewCell = "EmptyTableViewCell"
    private let descriptionHotelCell = "DescriptionHotelCell"
    private let nameCell = "NameCell"
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionTableViewCell>!
    private var sections: [SectionTableViewCell] = []
    var hotel: Hotel!
    private var homeViewController: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowNavigationBar = false
        initData()
        initUI()
    }
    
    func initData() {
        let descriptionContact = "- Địa chỉ: \(hotel.address) \n- Email: \(hotel.email) \n- Số điện thoại: \(hotel.phone)"
        sections = [
            SectionTableViewCell(header: EntityHeaderTableView.init(headerName: "", isCollapse: false), items: [EntityTableViewCell.init(name: "", description: ""), EntityTableViewCell.init(name: "", description: self.hotel.hotelDetail)]),
            SectionTableViewCell(header: EntityHeaderTableView.init(headerName: "Nhà hàng & Bar", isCollapse: false), items: [EntityTableViewCell.init(name: "", description: self.hotel.restaurant)]),
            SectionTableViewCell(header: EntityHeaderTableView.init(headerName: "Hội họp & Sự kiện", isCollapse: false), items: [EntityTableViewCell.init(name: "", description: self.hotel.events)]),
            SectionTableViewCell(header: EntityHeaderTableView.init(headerName: "Giải trí", isCollapse: false), items: [EntityTableViewCell.init(name: "", description: self.hotel.entertainment)]),
            SectionTableViewCell(header: EntityHeaderTableView.init(headerName: "Liên hệ", isCollapse: false), items: [EntityTableViewCell.init(name: "", description: descriptionContact)])
        ]
    }
    
    func initUI() {
        bookingButton.layer.cornerRadius = 8
        
        let tapImg = UITapGestureRecognizer.init(target: self, action: #selector(onBackNav))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapImg)
        backImageView.dropShadow()
        
        if !self.hotel.images.isEmpty && hotel.images.count > 0 {
            self.coverImageView.setImage(self.hotel.images)
        }
        
        self.initTableView()
    }

    func initTableView() {
        tableView.separatorColor = UIColor.clear
        
        let list: [String] = [nameCell, descriptionHotelCell, emptyTableViewCell]
        for item in list {
            tableView.register(UINib.init(nibName: item, bundle: nil), forCellReuseIdentifier: item)
        }
        
        tableView.register(UINib.init(nibName: headerDetailView, bundle: nil), forHeaderFooterViewReuseIdentifier: headerDetailView)
        
        tableView.rx
        .setDelegate(self)
        .disposed(by: disponseBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionTableViewCell>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    return self.getNameCell(indexPath: indexPath, item: item, tableView: tableView)
                } else {
                    return self.getDescriptionHotelCell(indexPath: indexPath, item: item, tableView: tableView)
                }
            } else if indexPath.section == 1 {
                let sectionE = dataSource[indexPath.section].header
                if sectionE.isCollapse {
                    return self.getEmptyCell(tableView: tableView)
                } else {
                    return self.getDescriptionHotelCell(indexPath: indexPath, item: item, tableView: tableView)
                }
            }
            else if indexPath.section == 2 {
                let sectionE = dataSource[indexPath.section].header
                if sectionE.isCollapse {
                    return self.getEmptyCell(tableView: tableView)
                } else {
                    return self.getDescriptionHotelCell(indexPath: indexPath, item: item, tableView: tableView)
                }
            }
            else if indexPath.section == 3 {
                let sectionE = dataSource[indexPath.section].header
                if sectionE.isCollapse {
                    return self.getEmptyCell(tableView: tableView)
                } else {
                    return self.getDescriptionHotelCell(indexPath: indexPath, item: item, tableView: tableView)
                }
            } else {
                return self.getDescriptionHotelCell(indexPath: indexPath, item: item, tableView: tableView)
            }
        })
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disponseBag)
    }
    
    func getEmptyCell(tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: emptyTableViewCell) as? EmptyTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func getNameCell(indexPath: IndexPath, item: EntityTableViewCell, tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.nameCell) as? NameCell {
            cell.binData(hotel: self.hotel)
            return cell
        }
        return UITableViewCell()
    }
    
    func getDescriptionHotelCell(indexPath: IndexPath, item: EntityTableViewCell, tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.descriptionHotelCell) as? DescriptionHotelCell {
            cell.lbDescription.text = item.description
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func onBackNav() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionBooking(_ sender: Any) {
        let bookingViewController = BookingViewController()
        bookingViewController.hotel = self.hotel
        bookingViewController.homeViewController = self.homeViewController
        navigationController?.pushViewController(bookingViewController, animated: true)
    }
}

extension DetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerDetailView) as? HeaderDetailView, section > 0 {
            view.lbTitleHeader.text = dataSource?[section].header.headerName
            view.onCollapse = { [unowned self] value in
                self.dataSource[section].header.isCollapse = !self.dataSource[section].header.isCollapse
                view.expandOrCollapse(self.dataSource[section].header.isCollapse)
                let indexPath = IndexPath.init(row: 0, section: section)
                self.tableView.beginUpdates()
                self.tableView.reloadItemsAtIndexPaths([indexPath], animationStyle: .none)
                self.tableView.endUpdates()
            }
            view.ivExpand.isHidden = section == 4
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 40 : CGFloat.leastNonzeroMagnitude
    }
}

struct SectionTableViewCell {
    var header: EntityHeaderTableView
    var items: [Item]
}

extension SectionTableViewCell: SectionModelType {
    typealias Item = EntityTableViewCell
    
    init(original: SectionTableViewCell, items: [Item]) {
       self = original
       self.items = items
     }
}

class EntityHeaderTableView {
    var headerName: String = ""
    var isCollapse: Bool = true

    init(headerName: String, isCollapse: Bool) {
        self.headerName = headerName
        self.isCollapse = isCollapse
    }
}

class EntityTableViewCell {
  var name: String = ""
  var description: String = ""
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

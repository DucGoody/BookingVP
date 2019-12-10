//
//  PopupFilterViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PopupFilterViewController: BaseViewController {
    private var tableView: UITableView!
    private var inputTodoView: UIView!
    private var tagItemSelected: Int = 0
    private var contentView: UIView!
    @IBOutlet weak var bakcgroundView: UIControl!
    
    var onSelectedItem: ((EntityPopup) -> (Void))?
    var isRoomType: Bool = false
    var datas: [EntityPopup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavigationBar = false
        self.initUI()
    }
    
    init(inputTodoView: UIView, datas: [EntityPopup], tagItemSelected: Int, isRoomType: Bool = false) {
        super.init(nibName: "PopupFilterViewController", bundle: nil)
        self.inputTodoView = inputTodoView
        self.datas = datas
        self.tagItemSelected = tagItemSelected
        self.isRoomType = isRoomType
    }
    
    required init?(coder: NSCoder) {
         super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     init UI
     created by Hoàng Văn Đức
     */
    func initUI() {
        var xTD = self.inputTodoView.frame.origin.x
        var yTD = self.inputTodoView.frame.origin.y + self.inputTodoView.frame.size.height
        let width = self.inputTodoView.frame.size.width

        var height = 37
        var isScroll = false
        if datas.count >= 1 && datas.count < 5 {
            height = 37 * datas.count
            isScroll = false
        } else {
            height = 37 * 5
            isScroll = true
        }
        
        if isRoomType {
            xTD = 16
            yTD += self.inputTodoView.frame.size.height * 2 + 12
        }
        
        self.contentView = UIView.init(frame: CGRect.init(x: xTD, y: yTD, width: width, height: CGFloat(height)))
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat(height)))
        tableView.isScrollEnabled = isScroll
        tableView.backgroundColor = UIColor.clear
        tableView.alpha = 1
        tableView.separatorColor = UIColor.clear
        tableView.layer.cornerRadius = 5
        tableView.register(UINib.init(nibName: "PopupFilterCell", bundle: nil), forCellReuseIdentifier: "PopupFilterCell")
        
        self.contentView.addSubview(tableView)
        self.bakcgroundView.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        
        self.initData()
        self.addShadow(view: self.contentView)
    }
    
    /*
     close popup
     created by Hoàng Văn Đức
     */
    func closePopup() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 0
        }) { (isCompleted) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /*
     init data popupup
     created by Hoàng Văn Đức
     */
    func initData() {
        let dataTable = Observable.just(datas)
        
        dataTable.bind(to: tableView.rx.items(cellIdentifier: "PopupFilterCell", cellType: PopupFilterCell.self)) {
            (row, item, cell) in
            cell.lbName.text = item.name
            cell.ivSelected.isHidden = !(item.tag == self.tagItemSelected)
        }.disposed(by: disponseBag)
        
        tableView.rx
        .modelSelected(EntityPopup.self)
        .subscribe(onNext:  { value in
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            self.onSelectedItem?(value)
            self.closePopup()
        })
        .disposed(by: disponseBag)
    }
    
    @IBAction func actionClickBackgroundView(_ sender: Any) {
        self.closePopup()
    }
    
    
    /*
     add shadow by view
     created by Hoàng Văn Đức
     */
    func addShadow(view: UIView) {
        view.layer.shadowPath =
            UIBezierPath(roundedRect: view.bounds,
              cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 6
        view.layer.masksToBounds = false
    }
}

class EntityPopup: NSObject {
    var tag: Int = 0
    var name: String = ""
    
    init(tag: Int, name: String) {
        self.tag = tag
        self.name = name
    }
}

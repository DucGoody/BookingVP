//
//  BaseViewController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/22/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BaseViewController: UIViewController {

    var isShowNavigationBar: Bool = true
    let disponseBag = DisposeBag()
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var viewDidicator: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initIndicator()
        self.showLoadingView(false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onBack))
    }
    
    @objc func onBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = !isShowNavigationBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func showLoadingView(_ isShow: Bool) {
        self.viewDidicator.isHidden = !isShow
    }
    
    func initIndicator() {
        self.viewDidicator.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        self.view.addSubview(self.viewDidicator)
        self.viewDidicator.snp.makeConstraints { (view) in
            view.height.equalTo(35)
            view.width.equalTo(35)
            view.centerX.equalTo(self.view.snp.centerX)
            view.centerY.equalTo(self.view.snp.centerY).inset(-30)
        }
        
        self.viewDidicator.addSubview(self.indicator)
        self.indicator.snp.makeConstraints { (indi) in
            indi.center.equalTo(self.viewDidicator)
        }
        self.indicator.startAnimating()
    }
}


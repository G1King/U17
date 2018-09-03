//
//  UBaseViewController.swift
//  U17
//
//  Created by Leo on 2018/7/17.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import SnapKit
import Reusable
import Then
import Kingfisher
class UBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    func  configUI() {}
    func configNavigationBar() {
        guard let nav = navigationController else {
            return
        }
        if nav.visibleViewController == self {
            nav.barStyle(.theme)
            nav.disablePopGesture = false
            nav.setNavigationBarHidden(false, animated: true)
            if nav.viewControllers.count > 1
            {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                   target: self,
                                                                   action: #selector(pressBack))
            }
            
        }
    }
    @objc func pressBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UBaseViewController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

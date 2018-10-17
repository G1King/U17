//
//  UTabBarController.swift
//  U17
//
//  Created by Leo on 2018/7/17.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false;
        // Do any additional setup after loading the view.
        addChild()
    }
    func addChild(){
        let homeVC = UHomeViewController(titles: ["推荐","VIP","订阅","排行"], vcs: [UBoutiqueListViewController(),UVIPListViewController(),USubscibeListViewController(),URankListViewController()], pageStyle: .navigationBarSement);
        addChildVC(homeVC, title: "首页", defaultImage: UIImage(named: "tab_home")!, selectImage: UIImage(named: "tab_home_S")!)
        let classVC = UCateListViewController();
        addChildVC(classVC, title: "分类", defaultImage: UIImage(named: "tab_class")!, selectImage: UIImage(named: "tab_class_S")!)
        
        let bookVC = UBookViewController(titles: ["收藏","书架","下载"], vcs: [UCollectListViewController(),UDocumentListViewController(),UDownloadListViewController()], pageStyle: .navigationBarSement);
        addChildVC(bookVC, title: "书架", defaultImage: UIImage(named: "tab_book")!, selectImage: UIImage(named: "tab_book_S")!)
        
        /// 我的
        let mineVC = UMineViewController();
        addChildVC(mineVC, title: "我的", defaultImage: UIImage(named: "tab_mine")!, selectImage: UIImage(named: "tab_mine_S")!)
    }
    func addChildVC(_ childVC: UIViewController , title: String , defaultImage: UIImage,selectImage: UIImage) {
        childVC.title = title;
        childVC.tabBarItem = UITabBarItem(title: nil, image: defaultImage.withRenderingMode(.alwaysOriginal), selectedImage: selectImage.withRenderingMode(.alwaysOriginal))
        if UIDevice.current.userInterfaceIdiom == .phone {
            childVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(UNavigationController(rootViewController: childVC));
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UTabBarController{
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        guard let select = selectedViewController else {
            return .lightContent;
        }
        return select.preferredStatusBarStyle;
    }
}

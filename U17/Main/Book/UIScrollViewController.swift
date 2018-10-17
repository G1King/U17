//
//  UIScrollViewController.swift
//  U17
//
//  Created by Leo on 2018/10/17.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UIScrollViewController: UBaseViewController {
    private lazy var mainScrollview: UBaseScrollview = {
        let sc = UBaseScrollview()
//        sc.delegate = self
        sc.isPagingEnabled = true
        return sc
    }()
    var arr = ["guide1","guide2","guide3"]
    override func viewDidLoad() {
        super.viewDidLoad()
view.addSubview(mainScrollview)
        // Do any additional setup after loading the view.
        mainScrollview.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH , height: SCREEN_HEIGHT);
        mainScrollview.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: SCREEN_HEIGHT)
        for item in 0..<arr.count {
            let imge: UIImageView = UIImageView(frame: CGRect(x: CGFloat((CGFloat(item)) * CGFloat(SCREEN_WIDTH)), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            imge.image = UIImage(named: arr[item])
            mainScrollview.addSubview(imge)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


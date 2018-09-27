//
//  UMineHead.swift
//  U17
//
//  Created by Leo on 2018/9/27.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UMineHead: UIView {

    private lazy var imge: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        addSubview(imge)
        imge.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(sexTypeDidChange), name: Notification.Name.USexTypeDidChangeNotificationName , object: nil)
        sexTypeDidChange()
    }
    @objc func sexTypeDidChange(){
        let sexType = UserDefaults.standard.integer(forKey: String.sexTypeKey)
        if sexType == 1 {
            imge.image = UIImage(named: "mine_bg_for_boy")
        } else {
            imge.image = UIImage(named: "mine_bg_for_girl")
        }
    }
}

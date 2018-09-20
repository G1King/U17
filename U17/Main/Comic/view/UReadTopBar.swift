//
//  UReadTopBar.swift
//  U17
//
//  Created by Leo on 2018/9/11.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UReadTopBar: UIView {

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nav_back_black"), for: .normal)
        return button
    }()
    lazy var title: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.textAlignment = .center
        tl.font = UIFont.boldSystemFont(ofSize: 18)
        return tl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI(){
    addSubview(backButton)
        backButton.snp.makeConstraints{
            $0.left.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        addSubview(title)
        title.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 50, 0, 50))
        }
    }
}

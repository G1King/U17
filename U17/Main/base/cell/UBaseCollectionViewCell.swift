//
//  UBaseCollectionViewCell.swift
//  U17
//
//  Created by Leo on 2018/7/31.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import Reusable
class UBaseCollectionViewCell: UICollectionViewCell,Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.backgroundColor = UIColor.white
        configUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI(){}
}

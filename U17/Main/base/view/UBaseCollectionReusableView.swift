//
//  UBaseCollectionReusableView.swift
//  U17
//
//  Created by Leo on 2018/8/20.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import Reusable
class UBaseCollectionReusableView: UICollectionReusableView ,Reusable{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func configUI(){}
}

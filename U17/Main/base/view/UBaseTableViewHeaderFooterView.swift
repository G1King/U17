//
//  UBaseTableViewHeaderFooterView.swift
//  U17
//
//  Created by Leo on 2018/9/25.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import Reusable
class UBaseTableViewHeaderFooterView: UITableViewHeaderFooterView,Reusable {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI() {}
}

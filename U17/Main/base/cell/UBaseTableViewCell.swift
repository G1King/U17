//
//  UBaseTableViewCell.swift
//  U17
//
//  Created by Leo on 2018/8/22.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import Reusable
class UBaseTableViewCell: UITableViewCell,Reusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    open func configUI(){}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none;
        // Configure the view for the selected state
    }

}

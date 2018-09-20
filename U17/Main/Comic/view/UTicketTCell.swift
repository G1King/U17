//
//  UTicketTCell.swift
//  U17
//
//  Created by Leo on 2018/9/4.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

/// 详情 本月月票 累计月票
class UTicketTCell: UBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model: DetailRealtimeModel? {
        didSet{
            guard let item = model else { return }
            let text = NSMutableAttributedString(string: "本月月票       |           累计月票  ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
            text.append(NSAttributedString(string: "\(item.comic?.total_ticket ?? "")", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.orange]))
            text.insert(NSAttributedString(string: "\(item.comic?.monthly_ticket ?? "" )", attributes: [NSAttributedStringKey.foregroundColor:UIColor.orange,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]), at: 6)
            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

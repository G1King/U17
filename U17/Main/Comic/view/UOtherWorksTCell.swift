//
//  UOtherWorksTCell.swift
//  U17
//
//  Created by Leo on 2018/9/4.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

/// 详情 其他作品cell
class UOtherWorksTCell: UBaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        accessoryType = .disclosureIndicator
//    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model: DetailStaticModel? {
        didSet{
            guard let item = model else { return }
            textLabel?.text = "其他作品"
            detailTextLabel?.text = "\(item.otherWorks?.count ?? 0)本"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

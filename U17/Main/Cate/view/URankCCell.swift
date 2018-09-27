//
//  URankCCell.swift
//  U17
//
//  Created by Leo on 2018/9/27.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class URankCCell: UBaseCollectionViewCell {
    private lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl
    }()
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(iconImageView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    var model : RankingModel? {
        didSet{
            guard let model = model else { return  }
            iconImageView.kf.setImage(urlString: model.cover)
            titleLabel.text = model.sortName
        }
    }
}

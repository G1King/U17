//
//  UBoardCCell.swift
//  U17
//
//  Created by Leo on 2018/7/31.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UBoardCCell: UBaseCollectionViewCell {
    lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill;
        icon.clipsToBounds = true
        return icon
    }()
    lazy var titleLbl: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .center
        return title
    }()
    override func configUI() {
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLbl)
        iconImageView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10);
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
        })
        titleLbl.snp.makeConstraints({
            $0.top.equalTo(iconImageView.snp.bottom)
            $0.left.right.equalToSuperview().inset(UIEdgeInsetsMake(0, 10, 0, 10))
            $0.height.equalTo(20)
        })
    }
    var model: ComicModel? {
        didSet{
            guard let model = model else { return  }
            iconImageView.kf.setImage(urlString: model.cover)
            titleLbl.text = model.name
        }
    }
}

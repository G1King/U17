//
//  UOtherWorksCollectionCell.swift
//  U17
//
//  Created by Leo on 2018/9/5.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UOtherWorksCollectionCell: UBaseCollectionViewCell {
   private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        iw.clipsToBounds = true
        return iw
    }()
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
   private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 13)
        return dl
    }()
    override func configUI() {
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsetsMake(0, 10, 0, 10))
            $0.height.equalTo(20)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(UIEdgeInsetsMake(0, 10, 0, 10))
            $0.height.equalTo(25)
            $0.bottom.equalTo(descLabel.snp.top)
        }
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
    }
    var model: OtherWorkModel? {
        didSet{
            guard let item = model else { return  }
            iconView.kf.setImage(urlString: item.coverUrl, placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = item.name
            descLabel.text = "更新至\(item.passChapterNum)话"
        }
    }
}

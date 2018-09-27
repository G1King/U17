//
//  UTopCCell.swift
//  U17
//
//  Created by Leo on 2018/9/27.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UTopCCell: UBaseCollectionViewCell {
    private lazy var iconImageView: UIImageView = {
    let img = UIImageView()
        img.contentMode = .scaleAspectFill
    return img
    }()
    override func configUI() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    var model : TopModel? {
        didSet {
            guard let model = model else { return  }
            iconImageView.kf.setImage(urlString: model.cover)
        }
    }
}

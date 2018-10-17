//
//  UChapterCCell.swift
//  U17
//
//  Created by Leo on 2018/9/7.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UChapterCCell: UBaseCollectionViewCell {
    private lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 16)
        return nl
    }()
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
    var chaptModel: ChapterStaticModel? {
        didSet{
            guard let model = chaptModel else {
                return
            }
            nameLabel.text = model.name
        }
    }
}

//
//  URankTCell.swift
//  U17
//
//  Created by Leo on 2018/9/20.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class URankTCell: UBaseTableViewCell {
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 0
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    override func configUI() {
        let line = UIView().then{
            $0.backgroundColor = UIColor.background
            contentView.addSubview($0)
            $0.snp.makeConstraints{
                $0.left.bottom.right.equalToSuperview()
                $0.height.equalTo(10)
            }
        }
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.left.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(line.snp.top).offset(-10);
            $0.width.equalToSuperview().multipliedBy(0.5);
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView).offset(20)
        }
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(iconView)
        }
        
        
    }
    var model: RankingModel? {
        didSet{
            guard let item = model else { return  }
            iconView.kf.setImage(urlString: item.cover)
            titleLabel.text = "\(item.title ?? "")"
            descLabel.text = item.subTitle
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

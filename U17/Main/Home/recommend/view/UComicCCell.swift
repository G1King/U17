//
//  UComicCCell.swift
//  U17
//
//  Created by Leo on 2018/8/28.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
enum UComicCCellStyle {
    case none
    case withTitle
    case withTitleAndDesc
}
class UComicCCell: UBaseCollectionViewCell {
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var descLbl: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 12)
        return dl
    }()
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(UIEdgeInsetsMake(0, 10, 0, 10));
            $0.height.equalTo(25)
            $0.bottom.equalToSuperview().offset(-10)
        }
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        contentView.addSubview(descLbl)
        descLbl.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(UIEdgeInsetsMake(0, 10, 0, 10));
            $0.height.equalTo(20);
            $0.top.equalTo(titleLabel.snp.bottom)
        }
    }
    var style: UComicCCellStyle = .withTitle{
        didSet{
            switch style {
            case .none:
                titleLabel.snp.updateConstraints{
                    $0.bottom.equalToSuperview().offset(25)
                }
                titleLabel.isHidden = true
                descLbl.isHidden = true
            case .withTitle:
                titleLabel.snp.updateConstraints{
                     $0.bottom.equalToSuperview().offset(-10)
                }
                titleLabel.isHidden = false
                descLbl.isHidden = true
            case .withTitleAndDesc:
                titleLabel.snp.updateConstraints{
                    $0.bottom.equalToSuperview().offset(-25)
                }
                titleLabel.isHidden = false
                descLbl.isHidden = false
            
          
        }
    }
 }
    var model: ComicModel?{
        didSet{
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover, placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name ?? model.title
            descLbl.text = model.subTitle ?? "更新志\(model.content ?? "0")集"
        }
    }
}

//
//  UComicTCell.swift
//  U17
//
//  Created by Leo on 2018/8/22.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UComicTCell: UBaseTableViewCell {
    var spinnerName: String?
   private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
  private lazy var titleLbl: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    private lazy var subTitleLbl: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
   private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderView: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()
    override func configUI() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView)
        }
        contentView.addSubview(subTitleLbl)
        subTitleLbl.snp.makeConstraints{
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(20)
            $0.top.equalTo(titleLbl.snp.bottom).offset(5)
        }
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints{
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLbl.snp.bottom).offset(5)
        }
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints{
            $0.bottom.equalTo(iconView.snp.bottom)
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints{
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(iconView.snp.bottom)
        }
    }
    var model: ComicModel? {
        didSet{
            guard let model = model else { return  }
            iconView.kf.setImage(urlString: model.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            titleLbl.text = model.name;
            subTitleLbl.text = "\(model.tags?.joined(separator: " ") ?? "") | \(model.author ?? "")"
            descLabel.text = model.description
            if spinnerName == "更新时间" {
                let tagString = getTimeInterval(time: model.conTag)
                tagLabel.text = "\(spinnerName!) \(tagString)"
                orderView.isHidden = true
            }else {
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                } else if model.conTag > 10000 {
                    tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                } else {
                    tagString = "\(model.conTag)"
                }
                if tagString != "0" { tagLabel.text = "\(spinnerName ?? "总点击") \(tagString)" }
                orderView.isHidden = false
            }
        }
    }
    var indexPath: IndexPath? {
        didSet{
            guard let indexPath = indexPath else { return  }
            if indexPath.row == 0 {
                orderView.image = UIImage.init(named: "rank_frist");
            }else if indexPath.row == 1{
                orderView.image = UIImage.init(named: "rank_second");
            }else if indexPath.row == 2 {
                orderView.image = UIImage.init(named: "rank_third");
            }else {
                orderView.image = nil;
            }
        }
    }
}

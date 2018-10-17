//
//  UDescriptionTCell.swift
//  U17
//
//  Created by Leo on 2018/9/3.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

/// 详情 介绍cell
class UDescriptionTCell: UBaseTableViewCell {

    lazy var textView: UITextView = {
      let tw = UITextView()
        tw.isUserInteractionEnabled = false
        tw.textColor = UIColor.gray
        tw.font = UIFont.systemFont(ofSize: 15)
        return tw
    }()
    override func configUI() {
        let titleLabel = UILabel().then{
            $0.text = "作品介绍"
            contentView.addSubview($0)
            $0.snp.makeConstraints{
                $0.left.top.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
                $0.height.equalTo(20)
            }
        }
        contentView.addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    var model: DetailStaticModel? {
        didSet{
            guard let item = model  else {return}
            DLog(item.comic?.description)
            textView.text = "【\(item.comic?.cate_id ?? "")】\(item.comic?.description ?? "")"
        }
    }
  class func height(for detailStaic: DetailStaticModel?) -> CGFloat {
        var height: CGFloat = 50;
        guard let model = detailStaic else { return height }
        let textView = UITextView().then{$0.font = UIFont.systemFont(ofSize: 15)}
        textView.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        height += textView.sizeThatFits(CGSize(width: SCREEN_WIDTH - 30, height: CGFloat.infinity)).height;
        return height
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

//
//  UCommentTCell.swift
//  U17
//
//  Created by Leo on 2018/9/10.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UCommentTCell: UBaseTableViewCell {
   private lazy var iconview: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 20
        icon.layer.masksToBounds = true
        return icon
    }()
   private lazy var nickNameLabel: UILabel = {
        let nl = UILabel()
        nl.textColor = UIColor.gray
        nl.font = UIFont.systemFont(ofSize: 13)
        return nl
    }()
    
  private  lazy var contentTextView: UITextView = {
        let cw = UITextView()
        cw.isUserInteractionEnabled = false
        cw.font = UIFont.systemFont(ofSize: 13)
        cw.textColor = UIColor.black
        return cw
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func configUI() {
        contentView.addSubview(iconview)
        iconview.snp.makeConstraints{
            $0.left.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints{
            $0.left.equalTo(iconview.snp.right).offset(10)
            $0.top.equalTo(iconview)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(15)
        }
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints{
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.right.left.equalTo(nickNameLabel)
            $0.bottom.greaterThanOrEqualToSuperview().offset(10)
        }
    }
    var model: UCommentViewModel? {
        didSet{
            guard let item = model else { return  }
            iconview.kf.setImage(urlString: item.model?.face)
            nickNameLabel.text = item.model?.nickname
            contentTextView.text = item.model?.content_filter
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class UCommentViewModel {
    var model: CommentModel?
    var height: CGFloat = 0
    
    convenience init(model: CommentModel) {
        self.init()
        self.model = model
        let tw =  UITextView().then{$0.font = UIFont.systemFont(ofSize: 13)}
        tw.text = model.content_filter
        let height = tw.sizeThatFits(CGSize(width: SCREEN_WIDTH - 70 , height: CGFloat.infinity)).height
        self.height = max(60, height + 45)
    }
    
}

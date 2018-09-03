//
//  UComicCHead.swift
//  U17
//
//  Created by Leo on 2018/8/20.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

typealias UComicHeadMoreActionClourse = ()-> Void

protocol UCmicHeadDeleage: class{
    func comicHead(_ comicHead: UComicCHead,moreAction button: UIButton)
}
class UComicCHead: UBaseCollectionReusableView {
  static let ucmicHeadFlag = "UCmicHeadFlag";
    
    weak var delegate: UCmicHeadDeleage?
    private var moreActionClourse: UComicHeadMoreActionClourse?
    lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    lazy var titleLbl: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl;
    }()
    
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("•••", for: .normal)
        mn.setTitleColor(UIColor.lightGray, for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        mn.addTarget(self, action: #selector(moreAction(button:)), for: .touchUpInside);
        return mn
    }()
    @objc func moreAction(button: UIButton){
       delegate?.comicHead(self, moreAction: button)
        guard let clouese = moreActionClourse else { return  }
        clouese()
    }
    func moreActionClourse(_ closure: UComicHeadMoreActionClourse?) {
        moreActionClourse = closure;
    }
    override func configUI() {
        backgroundColor = UIColor.white;
        addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{
            $0.left.equalTo(iconView.snp.right).offset(5)
            $0.centerY.height.equalTo(iconView)
            $0.width.equalTo(200)
        }
        addSubview(moreButton)
        moreButton.snp.makeConstraints{
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
    }
}

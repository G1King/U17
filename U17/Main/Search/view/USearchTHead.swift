//
//  USearchTHead.swift
//  U17
//
//  Created by Leo on 2018/9/25.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
typealias USearchTHeadActionClourse = () -> Void


protocol USearchTHeadDelegate: class {
    func searchTHead(_ searchThead: USearchTHead , moreAction button: UIButton)
}

class USearchTHead: UBaseTableViewHeaderFooterView {
    
     weak var  delegate: USearchTHeadDelegate?
    private var moreActionClosure: USearchTHeadActionClourse?
    
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.gray
        return title
    }()
    
    lazy var moreButton: UIButton = {
        let mb = UIButton()
        mb.setTitleColor(UIColor.lightGray, for: .normal)
        mb.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return mb
    }()
    @objc private func moreAction(button: UIButton){
      delegate?.searchTHead(self, moreAction: button)
        guard let clsoure = moreActionClosure else { return  }
        clsoure()
    }
    func moreActionClosure(_ closure: @escaping USearchTHeadActionClourse){
        moreActionClosure = closure
    }
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(200)
        }
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        let line = UIView().then { $0.backgroundColor = UIColor.background }
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

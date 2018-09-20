//
//  UChapterCHead.swift
//  U17
//
//  Created by Leo on 2018/9/7.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
typealias UChapterHeadSortClosure = (_ button: UIButton) -> Void
class UChapterCHead: UBaseCollectionReusableView {
    private var sortClosure: UChapterHeadSortClosure?
    
    private lazy var chapterLabel: UILabel = {
        let vl = UILabel()
        vl.textColor = UIColor.gray
        vl.font = UIFont.systemFont(ofSize: 13)
        return vl
    }()
    lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("倒序", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(sortAction(for:)), for: .touchUpInside)
        return button
    }()
 @objc func sortAction(for button: UIButton){
        guard let sortClosure = sortClosure else { return  }
         sortClosure(button)
    }
    func setClosure(_ closure: UChapterHeadSortClosure?){
        sortClosure = closure
    }
    override func configUI() {
        addSubview(sortButton)
        sortButton.snp.makeConstraints{
            $0.right.equalToSuperview()
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(44)
        }
        addSubview(chapterLabel)
        chapterLabel.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(sortButton.snp.left).offset(-10)
        }
    }
    var model: DetailStaticModel? {
        didSet{
            guard let item = model else { return  }
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            
            chapterLabel.text = "目录\(format.string(from: Date(timeIntervalSince1970: item.comic?.last_update_time ?? 0))) 更新\(item.chapter_list?.last?.name ?? "")"
        }
    }
}

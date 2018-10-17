//
//  USearchTFoot.swift
//  U17
//
//  Created by Leo on 2018/9/25.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
class USearchCCel: UBaseCollectionViewCell {
    lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    override func configUI() {
        layer.borderWidth = 1
        layer.backgroundColor = UIColor.background.cgColor
        contentView.addSubview(title)
        title.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    
}
typealias USearchTFootDidSelectIndexClosure = (_ index: Int , _ model: SearchItemModel) -> Void

protocol USearchTFootDelegate: class {
    func searchTFoot(_ search: USearchTFoot, didSelectItemAt index: Int , _ model: SearchItemModel )
}
class USearchTFoot: UBaseTableViewHeaderFooterView {
    weak var delegate: USearchTFootDelegate?
    private var didSelectIndexClosure: USearchTFootDidSelectIndexClosure?
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewAlignedLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        layout.horizontalAlignment = .left
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.dataSource = self
        cw.delegate = self
        cw.register(cellType: USearchCCel.self)
        return cw
    }()
    override func configUI() {
        contentView.addSubview(collectionView)
        contentView.backgroundColor = UIColor.white
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    var data: [SearchItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
}
extension USearchTFoot: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: USearchCCel.self)
        cell.layer.cornerRadius = cell.bounds.height * 0.5
        cell.title.text = data[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTFoot(self, didSelectItemAt: indexPath.row, data[indexPath.row])
        
        guard let closure = didSelectIndexClosure else { return  }
        closure(indexPath.row , data[indexPath.row])
    }
    func didSelectIndexClosure(_ closure: @escaping USearchTFootDidSelectIndexClosure){
        didSelectIndexClosure = closure
    }
}

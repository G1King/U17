//
//  UGuessLikeTCell.swift
//  U17
//
//  Created by Leo on 2018/9/4.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
typealias UGuessLikeTCellDidSelectClosure = (_ comic: ComicModel) -> Void
/// 详情 猜你喜欢cell
class UGuessLikeTCell: UBaseTableViewCell {
    private var didSelectClosure: UGuessLikeTCellDidSelectClosure?
    
   private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = self.contentView.backgroundColor
        cw.isScrollEnabled = false
        cw.dataSource = self
        cw.delegate = self
        cw.register(cellType: UComicCCell.self)
        return cw
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func configUI() {
        let titleLabel = UILabel().then{
            $0.text = "猜你喜欢"
            contentView.addSubview($0)
            $0.snp.makeConstraints{
                $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
                $0.height.equalTo(20)
            }
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.bottom.right.equalToSuperview()
        }
        
    }
    var model: GuessLikeModel? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UGuessLikeTCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.comics?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 50)/4)
        let height = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.style = .withTitle
        cell.model = model?.comics?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comic = model?.comics?[indexPath.row],let select = didSelectClosure else {return}
        select(comic)
    }
    func didSelectClosure(_ closure: UGuessLikeTCellDidSelectClosure?){
        didSelectClosure = closure
    }
}

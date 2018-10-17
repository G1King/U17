//
//  USubscibeListViewController.swift
//  U17
//
//  Created by Leo on 2018/7/26.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class USubscibeListViewController: UBaseViewController {
    private var subscribeList = [ComicListModel]()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.background
        cw.alwaysBounceVertical = true
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        cw.uHead = URefreshHeader{[weak self] in
            self?.loadData()
        }
        cw.uFoot = URefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        cw.uempty = UEmptyView{
            [weak self] in
            self?.loadData()
        }
        cw.register(cellType: UComicCCell.self)
        cw.dataSource = self;
        cw.delegate = self
        return cw
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    func loadData() {
        ApiLoadingProvider.request(API.subscribeList, model: SubscribeListModel.self) { [weak self] (data) in
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.subscribeList = data?.newSubscribeList ?? []
            
            self?.collectionView.reloadData()
        }
    }
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
extension USubscibeListViewController : UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.subscribeList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = subscribeList[section]
        return count.comics?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UComicCHead.self)
            let comicList = subscribeList[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
            head.titleLbl.text = comicList.itemTitle
            head.moreButton.isHidden = !comicList.canMore
            head.moreActionClourse{
                [weak self] in
                let vc = UComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                vc.title = comicList.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return head
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: UComicCFoot.self)
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let count = subscribeList[section]
        return count.itemTitle?.count ?? 0 > 0 ? CGSize(width: SCREEN_WIDTH, height: 44) : CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return subscribeList.count - 1 != section ? CGSize(width: SCREEN_WIDTH, height: 10) : CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        let model =  subscribeList[indexPath.section]
        cell.model = model.comics?[indexPath.row]
        cell.style = .withTitle
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = floor(Double(SCREEN_WIDTH - 10) / 3)
        return CGSize(width: w, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = subscribeList[indexPath.section]
        guard let item = model.comics?[indexPath.row] else {
            return
        }
        let vc = UComicViewController(comicid: item.comicId)
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

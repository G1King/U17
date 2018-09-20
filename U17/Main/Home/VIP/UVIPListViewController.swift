//
//  UVIPListViewController.swift
//  U17
//
//  Created by Leo on 2018/7/26.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit


class UVIPListViewController: UBaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let it = UICollectionViewFlowLayout()
        it.minimumLineSpacing = 10
        it.minimumInteritemSpacing = 5
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: it)
        cw.backgroundColor = UIColor.background
        cw.alwaysBounceVertical = true
        cw.delegate = self
        cw.dataSource = self
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionElementKindSectionHeader)
        cw.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionElementKindSectionFooter)
        cw.register(cellType: UComicCCell.self)
        cw.uHead = URefreshHeader{
            [weak self] in
            self?.loadData()
        }
        cw.uFoot = URefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        cw.uempty = UEmptyView{
             [weak self] in
            self?.loadData()
        }
        return cw
    }()
    private var vipList = [ComicListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    func loadData()  {
        ApiLoadingProvider.request(API.vipList, model: VipListModel.self) { [weak self] (data) in
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            self?.vipList = data?.newVipList ?? []
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
extension UVIPListViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.vipList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.vipList[section]
        return count.comics?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        let model = self.vipList[indexPath.section]
        cell.style = .withTitle
        cell.model = model.comics?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if kind == UICollectionElementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: UComicCHead.self)
            let comiclist = self.vipList[indexPath.section]
            head.iconView.kf.setImage(urlString: comiclist.titleIconUrl)
            head.titleLbl.text = comiclist.itemTitle
            head.moreButton.isHidden = !comiclist.canMore
            head.moreActionClourse{
                [weak self] in
                let vc  = UComicListViewController(argCon: comiclist.argCon, argName: comiclist.argName, argValue: comiclist.argValue)
                vc.title = comiclist.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            return head
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: indexPath, viewType: UComicCFoot.self)
            return footer
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let comiclist = vipList[section]
        return comiclist.itemTitle?.count ?? 0 > 0 ? CGSize(width: SCREEN_WIDTH, height: 44) : CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = floor(Double(SCREEN_WIDTH - 10) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.vipList[indexPath.section]
        guard let item = model.comics?[indexPath.row] else {return}
        let vc =  UComicViewController(comicid: item.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

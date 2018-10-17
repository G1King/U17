//
//  UCateListViewController.swift
//  U17
//
//  Created by Leo on 2018/7/17.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UCateListViewController: UBaseViewController {
    private var searchString = ""
    private var topList = [TopModel]()
    private var rankList = [RankingModel]()
    
    private lazy var searchBurron: UIButton = {
        let sn = UIButton(type: .system)
        sn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 30)
        sn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        sn.layer.cornerRadius = 15
        sn.setTitleColor(.white, for: .normal)
        sn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        sn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        sn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return sn
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.dataSource = self
        cw.delegate = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: URankCCell.self)
        cw.register(cellType: UTopCCell.self)
        cw.uHead = URefreshHeader{
            [weak self] in
            self?.loadData()
        }
        cw.uempty = UEmptyView{
            [weak self] in
            self?.loadData()
        }
        return cw
    }()
    @objc func searchAction(){
        navigationController?.pushViewController(USearchViewController(), animated: true)
    }
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }
    func loadData(){
        ApiLoadingProvider.request(API.cateList, model: CateListModel.self) { [weak self] (data) in
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            self?.rankList = data?.rankingList ?? []
            self?.topList = data?.topList ?? []
            self?.collectionView.reloadData()
            self?.searchString = data?.recommendSearch ?? ""
            self?.searchBurron.setTitle(self?.searchString, for: .normal)
        }
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchBurron
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UCateListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.prefix(3).count
        }else {
            return rankList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UTopCCell.self)
            cell.model = topList[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: URankCCell.self)
            cell.model = rankList[indexPath.row]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((SCREEN_WIDTH - 40) / 3)
        
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
         let model = topList[indexPath.row]
            var vcs: [UIViewController] = []
            var titles: [String] = []
            for tab in model.extra?.tabList ?? [] {
                guard let tabTitles = tab.tabTitle else {continue}
                titles.append(tabTitles)
                vcs.append(UComicListViewController(argCon: tab.argCon, argName: tab.argName, argValue: tab.argValue))
            }
            let vc = UPageViewController(titles: titles, vcs: vcs, pageStyle: .topTabBar)
            navigationController?.pushViewController(vc, animated: true)
        }else {
           let model = rankList[indexPath.row]
          let vc = UComicListViewController(argCon: model.argCon, argName: model.argName, argValue: model.argValue)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

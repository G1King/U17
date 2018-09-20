//
//  URankListViewController.swift
//  U17
//
//  Created by Leo on 2018/7/26.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class URankListViewController: UBaseViewController {
    private var rankList = [RankingModel]()
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: CGRect.zero, style: .plain)
        tw.backgroundColor = UIColor.background
        tw.separatorStyle = .none
        tw.delegate = self
        tw.dataSource = self
        tw.tableFooterView = UIView()
        tw.register(cellType: URankTCell.self)
        tw.uHead = URefreshHeader{
            [weak self] in
            self?.loadData()
        }
        tw.uempty = UEmptyView{
            [weak self] in
            self?.loadData()
        }
        return tw
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }
    override func configUI() {
        tableView.then{
            view.addSubview($0)
            $0.snp.makeConstraints{
                $0.edges.equalTo(self.view.usnp.edges)
            }
        }
    }
    func loadData(){
        ApiLoadingProvider.request(API.rankList, model: RankinglistModel.self) { [weak self] (data) in
            self?.tableView.uHead.endRefreshing()
            self?.tableView.uempty?.allowShow = true
            
            self?.rankList = data?.rankinglist ?? []
            self?.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension URankListViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: URankTCell.self)
        cell.model = rankList[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH * 0.4;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rankList[indexPath.row]
        let vc = UComicListViewController(argCon: model.argCon, argName: model.argName, argValue: model.argValue)
      vc.title = "\(model.title!)榜"
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

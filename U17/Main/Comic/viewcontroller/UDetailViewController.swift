//
//  UDetailViewController.swift
//  U17
//
//  Created by Leo on 2018/8/29.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UDetailViewController: UBaseViewController {
  weak var delegate: UComicViewWillEndDraggingDelegate?
    
    var detailStatic: DetailStaticModel?
    var detailRealtime: DetailRealtimeModel?
    var guessLike: GuessLikeModel?
    private lazy var tableview: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.background
        tw.separatorStyle = .none
        tw.dataSource = self
        tw.delegate = self
        return tw
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func reloadData() {
        tableview.reloadData()
    }
    override func configUI() {
        view.addSubview(tableview)
        tableview.snp.makeConstraints{$0.edges.equalTo(self.view.usnp.edges)}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension UDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.comicWillEndDragging(scrollView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailStatic != nil ? 4 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? 0 : 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
    }
}

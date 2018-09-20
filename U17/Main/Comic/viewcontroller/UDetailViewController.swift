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
        tw.register(cellType: UDescriptionTCell.self)
        tw.register(cellType: UOtherWorksTCell.self)
        tw.register(cellType: UTicketTCell.self)
        tw.register(cellType: UGuessLikeTCell.self)
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UDescriptionTCell.self)
            cell.model = detailStatic
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UOtherWorksTCell.self)
            cell.model = detailStatic
            return cell
        }else if indexPath.section == 2{
            let  cell = tableView.dequeueReusableCell(for: indexPath, cellType: UTicketTCell.self)
            cell.model = detailRealtime
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UGuessLikeTCell.self)
            cell.model = guessLike
            cell.didSelectClosure { [weak self](comic) in
                let vc = UComicViewController(comicid: comic.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UDescriptionTCell.height(for: detailStatic)
        }else if indexPath.section == 3{
            return 200
        }else {
            return 44
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UOtherWorksViewController(otherWorks: detailStatic?.otherWorks)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? CGFloat.leastNormalMagnitude : 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

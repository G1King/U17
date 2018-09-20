//
//  UCommentViewController.swift
//  U17
//
//  Created by Leo on 2018/8/29.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UCommentViewController: UBaseViewController {
    weak var delegate: UComicViewWillEndDraggingDelegate?
    var detailStatic: DetailStaticModel?
    var commentList: CommentListModel? {
        didSet{
           guard let commentList = commentList?.commentList else { return  }
            let vmArray = commentList.compactMap { (comment) -> UCommentViewModel? in
                return UCommentViewModel(model: comment)
            }
            listArray.append(contentsOf: vmArray)
        }
    }
    private var listArray = [UCommentViewModel]()
    private lazy var tabelView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.register(cellType: UCommentTCell.self)
        tb.uFoot = URefreshFooter{self.loadData()}
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func reloadData() {
       tabelView.reloadData()
    }
    func loadData(){
        ApiProvider.request(API.commentList(object_id: detailStatic?.comic?.comic_id ?? 0, thread_id: detailStatic?.comic?.thread_id ?? 0 , page: commentList?.serverNextPage ?? 0), model: CommentListModel.self) { (returnData) in
            if returnData?.hasMore == true {
                self.tabelView.uFoot.endRefreshing()
            }else {
                self.tabelView.uFoot.endRefreshingWithNoMoreData()
            }
            self.commentList = returnData
            self.tabelView.reloadData()
        }
    }
    override func configUI() {
        view.addSubview(tabelView)
        tabelView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UCommentViewController : UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  listArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return  listArray[indexPath.row].height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UCommentTCell.self)
        cell.model = listArray[indexPath.row]
        return cell
    }
}

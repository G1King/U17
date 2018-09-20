//
//  UComicViewController.swift
//  U17
//
//  Created by Leo on 2018/8/28.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

protocol UComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollview: UIScrollView)
}

class UComicViewController: UBaseViewController {
    private var comicid : Int = 0;
    private lazy var mainScrollview: UBaseScrollview = {
        let sc = UBaseScrollview()
        sc.delegate = self
        return sc
    }()
    private lazy var detailVC: UDetailViewController = {
        let dc = UDetailViewController()
        dc.delegate = self
        return dc
    }()
    
    private lazy var chapterVC: UChapterViewController = {
        let cc = UChapterViewController()
        cc.delegate = self;
        return cc;
    }()
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    private lazy var commentVC: UCommentViewController = {
        let cc = UCommentViewController()
        cc.delegate = self
        return cc
    }()
    
    private lazy var pageVC: UPageViewController = {
        
        return UPageViewController(titles: ["详情","目录","评论"], vcs: [detailVC,chapterVC,commentVC], pageStyle: .topTabBar)
    }()
    private lazy var headView: UComicHead = {
        
        return UComicHead(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarY + 150))
    }()
    private var detailStatic: DetailStaticModel?
    private var detailRealtime: DetailRealtimeModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = .top
      loadData()
//        let g = navigationController?.view.gestureRecognizers
//        for gesture in g! {
//            if gesture .isKind(of: UIScreenEdgePanGestureRecognizer.self){
//                if mainScrollview.contentOffset.x == 0{
//                    mainScrollview.panGestureRecognizer .require(toFail: gesture)
//                    
//                }
//            }
//        }
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.barStyle(.clear)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.barStyle(.theme)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        ApiLoadingProvider.request(API.detailStatic(comicid: comicid), model: DetailStaticModel.self) { [weak self] (detailStatic) in
            self?.detailStatic = detailStatic
            self?.headView.detailStatic = detailStatic?.comic
            self?.detailVC.detailStatic = detailStatic
            self?.chapterVC.detailStatic = detailStatic
            self?.commentVC.detailStatic = detailStatic
            ApiProvider.request(API.commentList(object_id: detailStatic?.comic?.comic_id ?? 0, thread_id: detailStatic?.comic?.thread_id ?? 0, page: -1), model: CommentListModel.self, completion: { [weak self] (commentList) in
                self?.commentVC.commentList = commentList
                group.leave()
            })
            
        }
        group.enter()
        ApiProvider.request(API.detailRealtime(comicid: comicid), model: DetailRealtimeModel.self) { [weak self] (returnData) in
            self?.detailRealtime = returnData
            self?.headView.detailRealTime = returnData?.comic
            self?.detailVC.detailRealtime = returnData
            self?.chapterVC.detailRealtime = returnData
            group.leave()
        }
        group.enter()
        ApiProvider.request(API.guessLike, model: GuessLikeModel.self) { [weak self] (returnData) in
            self?.detailVC.guessLike = returnData
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
            self.chapterVC.reloadData()
            self.commentVC.reloadData()
        }
        
    }
    override func configUI() {
        view.addSubview(mainScrollview)
        mainScrollview.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        let contentView = UIView()
        mainScrollview.addSubview(contentView)
//        contentView.backgroundColor = UIColor.red
        
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-navigationBarY)
        }
        DLog(contentView.bounds.size.height)
        addChildViewController(pageVC)
        contentView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        mainScrollview.parallaxHeader.view = headView
        mainScrollview.parallaxHeader.height = navigationBarY + 150
        mainScrollview.parallaxHeader.minimumHeight = navigationBarY
        mainScrollview.parallaxHeader.mode = .fill
    }
    override func configNavigationBar() {
        super.configNavigationBar()
//        navigationController?.barStyle(.clear)
        mainScrollview.contentOffset = CGPoint(x: 0, y: -mainScrollview.parallaxHeader.height)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UComicViewController : UIScrollViewDelegate, UComicViewWillEndDraggingDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        DLog(scrollView.contentOffset.y)
//        DLog(mainScrollview.parallaxHeader.minimumHeight)
       
        if scrollView.contentOffset.y >= -mainScrollview.parallaxHeader.minimumHeight {
            
            navigationController?.barStyle(.theme)
            
            navigationItem.title = detailStatic?.comic?.name
        }else{
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
            
        }
    }
    func comicWillEndDragging(_ scrollview: UIScrollView) {
        DLog(self.mainScrollview.parallaxHeader.minimumHeight)
        DLog(self.mainScrollview.parallaxHeader.height)
        if scrollview.contentOffset.y > 0 {
            mainScrollview.setContentOffset(CGPoint(x: 0, y: -self.mainScrollview.parallaxHeader.minimumHeight), animated: true)
        }else if scrollview.contentOffset.y < 0 {
            mainScrollview.setContentOffset(CGPoint(x: 0, y: -self.mainScrollview.parallaxHeader.height), animated: true)
        }
    }
}

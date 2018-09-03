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
   private lazy var mainScrollview: UIScrollView = {
        let sc = UIScrollView()
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
        return cc;
    }()
    private lazy var navigationBarY: CGFloat = {
       return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    private lazy var commentVC: UCommentViewController = {
       let cc = UCommentViewController()
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
       
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
            
            group.leave()
        }
        group.enter()
        ApiProvider.request(API.detailRealtime(comicid: comicid), model: DetailRealtimeModel.self) { [weak self] (returnData) in
            self?.detailRealtime = returnData
            self?.headView.detailRealTime = returnData?.comic
            self?.detailVC.detailRealtime = returnData
            group.leave()
        }
        group.enter()
        ApiProvider.request(API.guessLike, model: GuessLikeModel.self) { [weak self] (returnData) in
            self?.detailVC.guessLike = returnData
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
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
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-navigationBarY)
        }
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
        navigationController?.barStyle(.clear)
        mainScrollview.contentOffset = CGPoint(x: 0, y: -mainScrollview.parallaxHeader.height)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension UComicViewController : UIScrollViewDelegate, UComicViewWillEndDraggingDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DLog(scrollView.contentOffset.y)
        DLog(mainScrollview.parallaxHeader.minimumHeight)
        if scrollView.contentOffset.y >= -mainScrollview.parallaxHeader.minimumHeight {
        
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.navigationController?.barStyle(.theme)
                
                self?.navigationController?.title = self?.detailStatic?.comic?.name
            }
        }else{
      
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.navigationController?.barStyle(.clear)
                self?.navigationController?.title = ""
            }
        }
    }
    func comicWillEndDragging(_ scrollview: UIScrollView) {
        if scrollview.contentOffset.y > 0 {
            mainScrollview.setContentOffset(CGPoint(x: 0, y: -self.mainScrollview.parallaxHeader.minimumHeight), animated: true)
        }else if scrollview.contentOffset.y < 0 {
            mainScrollview.setContentOffset(CGPoint(x: 0, y: -self.mainScrollview.parallaxHeader.height), animated: true)
        }
    }
}

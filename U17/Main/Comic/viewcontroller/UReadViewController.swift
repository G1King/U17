//
//  UReadViewController.swift
//  U17
//
//  Created by Leo on 2018/9/10.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UReadViewController: UBaseViewController {
    private var chapterList = [ChapterModel]()
    private var detailStatic: DetailStaticModel?
    private var selectIndex: Int = 0
    private var previousIndex: Int = 0
    private var nextIndex: Int = 0
    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }else {
            return .zero
        }
    }
    
    private var isLandscapeRight: Bool! {
        didSet{
            UIApplication.changeOrientationTo(landscapeRight: isLandscapeRight)
            collectionView.reloadData()
        }
    }
    private var isBarHidden: Bool = false {
        didSet{
            UIView.animate(withDuration: 0.5) {
                self.topBar.snp.updateConstraints{
                    $0.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgeInsets.top + 44) : 0)
                }
                self.bottomBar.snp.updateConstraints{
                    $0.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (-self.edgeInsets.bottom + 120) : 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    private  lazy var backScrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.delegate = self
        sc.minimumZoomScale = 1.0;
        sc.maximumZoomScale = 1.5;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        sc.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        sc.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        return sc
    }()
    private lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.sectionInset = .zero
        fl.minimumLineSpacing = 10
        fl.minimumInteritemSpacing = 5
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: fl)
        cw.backgroundColor = UIColor.white
        cw.register(cellType: UReadCCell.self)
        cw.uHead = URefreshAutoHeader{
            [weak self] in
            let pre = self?.previousIndex ?? 0
            
            self?.loadData(with: pre, isPreious: true, neddClear: false, finished: { [weak self](finish) in
                self?.previousIndex = pre - 1
            })
        }
        cw.uFoot = URefreshAutoFooter{
            [weak self] in
            let next = self?.nextIndex ?? 0
            self?.loadData(with: next, isPreious: false, neddClear: false, finished: { [weak self] (finish) in
                self?.nextIndex  = next + 1
            })
        }
        cw.delegate = self
        cw.dataSource = self
        return cw
    }()
   private lazy var topBar: UReadTopBar = {
        let br = UReadTopBar()
        br.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        return br
    }()
  private lazy var bottomBar: UReadBottomBar = {
        let bottom = UReadBottomBar()
    bottom.deviceButton.addTarget(self, action: #selector(changeDeviceDirection(_ :)), for: .touchUpInside)
    bottom.chapterButton.addTarget(self, action: #selector(changeChapter(_ :)), for: .touchUpInside)
    bottom.lightButton.addTarget(self, action: #selector(changeLight(_ :)), for: .touchUpInside)
    bottom.menuSlider.addTarget(self, action: #selector(addChapter(_ :)), for: .valueChanged)
        return bottom
    }()
    
    /// lifeCycle
    
    convenience init(detailStatic: DetailStaticModel? ,selectIndex: Int) {
        self.init()
        self.detailStatic = detailStatic
        self.selectIndex = selectIndex
        self.previousIndex = selectIndex - 1
        self.nextIndex = selectIndex + 1
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData(with: selectIndex, isPreious: false, neddClear: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLandscapeRight = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isLandscapeRight = false
    }
    override func configUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints{$0.edges.equalTo(self.view.usnp.edges)}
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.width.equalTo(backScrollView)
        }
        view.addSubview(topBar)
        topBar.snp.makeConstraints{
            $0.left.top.right.equalTo(self.backScrollView)
            $0.height.equalTo(44)
        }
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints{
            $0.left.right.bottom.equalTo(self.backScrollView)
            $0.height.equalTo(120)
        }
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.white)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_black"), target: self, action: #selector(pressBack))
        navigationController?.disablePopGesture = true
    }
    ///request
    func loadData(with index: Int, isPreious: Bool, neddClear: Bool, finished:( (_ finished: Bool) -> Void)? = nil  ){
        guard let detailStatic = detailStatic else { return  }
        topBar.title.text = detailStatic.comic?.name
        
        if index <= -1 {
            collectionView.uHead.endRefreshing()
            UNoticeBar(config: UNoticeBarConfig(title:"亲,这已经是第一页了")).show(duration: 2)
        }else if index >= detailStatic.chapter_list?.count ?? 0 {
            collectionView.uFoot.endRefreshingWithNoMoreData()
            UNoticeBar(config: UNoticeBarConfig(title:"亲,这已经是最后一页了")).show(duration: 2)
        }else {
            guard let chapterId = detailStatic.chapter_list?[index].chapter_id else {return}
            ApiLoadingProvider.request(API.chapter(chapter_id: chapterId), model: ChapterModel.self) { [weak self] (data) in
                self?.collectionView.uHead.endRefreshing()
                self?.collectionView.uFoot.endRefreshing()
                guard let chapter = data else {return}
                if neddClear {self?.chapterList.removeAll()}
                if isPreious {
                    self?.chapterList.insert(chapter, at: 0)
                }else {
                    self?.chapterList.append(chapter)
                }
                self?.collectionView.reloadData()
                guard let finished = finished else { return }
                finished(true)
            }
        }
    }
    /// methods
    @objc func tapAction(){
        isBarHidden = !isBarHidden
    }
    @objc func doubleTapAction(){
        
    }
    @objc func changeDeviceDirection(_ button: UIButton) {
        isLandscapeRight = !isLandscapeRight;
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }else {
            button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    @objc func changeLight(_ button: UIButton){
        UIScreen.main.brightness = 0.5
    }
    @objc func changeChapter(_ button: UIButton) {
        
    }
    @objc func addChapter(_ slider: UISlider){
        var index: Int = 0 ;
        if slider.value == 1.0 {
            index = (chapterList[0].image_list?.count)! - 1;
        }else{
            index = Int(floorf( slider.value * Float((chapterList[0].image_list?.count)!)))
            
        }
        collectionView.scrollToItem(at: NSIndexPath.init(item: index, section: 0) as IndexPath, at: .top, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension UReadViewController: UIScrollViewDelegate , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chapterList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList[section].image_list?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      guard let img = chapterList[indexPath.section].image_list?[indexPath.row] else { return CGSize.zero }
        let width = backScrollView.frame.width
        let height = floor(width / CGFloat(img.width) * CGFloat(img.height))
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UReadCCell.self)
        cell.model = chapterList[indexPath.section].image_list?[indexPath.row]
        return cell
    }
}

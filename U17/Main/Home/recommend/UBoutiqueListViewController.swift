//
//  UBoutiqueListViewController.swift
//  U17
//
//  Created by Leo on 2018/7/26.
//  Copyright © 2018年 SPIC. All rights reserved.
//
import UIKit
import LLCycleScrollView

class UBoutiqueListViewController: UBaseViewController {
    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    private var galleryItems = [GalleryItemModel]()
    private var TextItems = [TextItemModel]()
    private var comicLists = [ComicListModel]()
   
    private lazy var bannerview: LLCycleScrollView = {
        let bw = LLCycleScrollView();
        bw.backgroundColor = UIColor.background
        bw.autoScrollTimeInterval = 5
        bw.placeHolderImage = UIImage(named: "normal_placeholder")
        bw.coverImage = UIImage()
        bw.pageControlPosition = .right;
        bw.pageControlBottom = 20;
        bw.titleBackgroundColor = UIColor.clear
        bw.lldidSelectItemAtIndex = didSelectBanner(index:)
        return bw
    }()
    private lazy var sexTypeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(changeSex), for: .touchUpInside)
        return button
    }()
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.minimumInteritemSpacing = 0.01
        layout.minimumLineSpacing = 10
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.background
        collection.delegate = self;
        collection.dataSource = self;
        collection.alwaysBounceVertical = true
        collection.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH * 0.467, 0, 0, 0)
        collection.scrollIndicatorInsets = collection.contentInset
        collection.register(cellType: UComicCCell.self)
        collection.register(cellType: UBoardCCell.self)
        collection.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionElementKindSectionHeader)
        collection.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionElementKindSectionFooter)
        
        return collection;
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchData(false)
    }
    
   
    override func configUI() {
        view.addSubview(collection)
        collection.snp.makeConstraints { $0.edges.equalToSuperview()
        }
        view.addSubview(bannerview)
        bannerview.snp.makeConstraints({
         $0.left.top.right.equalToSuperview()
         $0.height.equalTo(collection.contentInset.top);
        })
        view.addSubview(sexTypeButton)
        sexTypeButton.snp.makeConstraints({
            $0.width.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview()
        })
    }
//   FETCH DATA  fale woman
    private func fetchData(_ changeSex: Bool){
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.set(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name.USexTypeDidChangeNotificationName, object: nil)
        }
        ApiLoadingProvider.request(API.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) { [weak self] (result) in
             self?.galleryItems = result?.galleryItems ?? []
             self?.TextItems = result?.textItems ?? []
             self?.comicLists = result?.comicLists ?? []
            
             self?.sexTypeButton.setImage(UIImage(named: self?.sexType == 1 ? "gender_male" : "gender_female"), for: .normal)
//             self?.collection.uHead.endRefreshing()
            self?.collection.uempty?.allowShow = true
            self?.collection.reloadData()
            self?.bannerview.imagePaths = self?.galleryItems.filter{ $0.cover != nil
                }.map{$0.cover!} ?? []
        }
        
    }
    
//  ACTION
    //点击轮播
    private func didSelectBanner(index: NSInteger) {
        let item = galleryItems[index]
      
        if item.linkType == 2{
            
            guard let url = item.ext?.compactMap({ $0.key == "url" ? $0.val : nil }).joined() else {return}
            let vc = UWebViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }else {
            guard let comicIdString = item.ext?.compactMap({$0.key == "comicId" ? $0.val : nil}).joined(),let comicId = Int(comicIdString) else {return}
            print(comicIdString)
            let vc = UComicViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    @objc private func changeSex(){
        fetchData(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UBoutiqueListViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return comicLists.count
   }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let comicList = comicLists[section]
        return comicList.comics?.prefix(4).count ?? 0;
   }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let head  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: UComicCHead.self)
            let comiclist = comicLists[indexPath.section];
            head.iconView.kf.setImage(urlString: comiclist.newTitleIconUrl);
            head.titleLbl.text = comiclist.itemTitle
            head.moreActionClourse{ [weak self] in
                if comiclist.comicType == .thematic {
//                    let vc = UPageViewController(titles: ["漫画","次元"], vcs: [USpecial], pageStyle: <#T##UIPageStyle#>)
                }else if comiclist.comicType == .animation{
                    
                }else if comiclist.comicType == .update{
                    
                }else {
                let vc = UComicListViewController(argCon: comiclist.argCon, argName: comiclist.argName, argValue: comiclist.argValue)
                    vc.title = comiclist.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            return head;
        }else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: indexPath, viewType: UComicCFoot.self)
            return foot
        }
    }
   
  public  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
     let comicList = comicLists[section]
    return  comicList.itemTitle?.count ?? 0 > 0 ?  CGSize(width: SCREEN_WIDTH, height: 44) : CGSize.zero
    }
   
 public  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return comicLists.count - 1 != section ? CGSize(width: SCREEN_WIDTH, height: 10) : CGSize.zero
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
//        return UIEdgeInsetsMake(0, 0, 0, 1)
//    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cmicList = comicLists[indexPath.section]
        if cmicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UBoardCCell.self)
            cell.model = cmicList.comics?[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
            if cmicList.comicType == .thematic{
                cell.style = .none
            }else{
                cell.style = .withTitleAndDesc
            }
            cell.model = cmicList.comics?[indexPath.row]
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let with = floor((SCREEN_WIDTH - 15.0) / 4.0)
            return CGSize(width: with, height: 80);
        }else {
            if comicList.comicType == .thematic {
                let width = floor((SCREEN_WIDTH - 5.0)/2)
                return CGSize(width: width, height: 120)
            }else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let wrap = count % 2 + 2
                let width = floor((SCREEN_WIDTH - CGFloat(wrap - 1) * 5.0) / CGFloat(wrap))
                return CGSize(width: width, height: CGFloat(wrap * 80))
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comiclists = comicLists[indexPath.section]
        guard let item = comiclists.comics?[indexPath.row] else {return}
        if comiclists.comicType == .billboard {
            let vc = UComicListViewController( argName: item.argName, argValue: item.argValue)
            navigationController?.pushViewController(vc, animated: true)
        }else {
            if item.linkType == 2{
                guard let url = item.ext?.compactMap({return $0.key == "url" ? $0.val : nil}).joined() else {return}
                let  vc = UWebViewController(url: url)
                navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = UComicViewController(comicid: item.comicId)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collection {
//            print("\(scrollView.contentOffset.y) \(scrollView.contentInset.top)  \(min(0,-(scrollView.contentOffset.y  + scrollView.contentInset.top)))")
            bannerview.snp.updateConstraints{
            $0.top.equalToSuperview().offset(min(0,-(scrollView.contentOffset.y  + scrollView.contentInset.top)))
            }
        }
       
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collection {
            UIView.animate(withDuration: 0.5) {
                self.sexTypeButton.transform = CGAffineTransform(translationX: 50, y: 0)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collection {
            UIView.animate(withDuration: 0.5) {
                self.sexTypeButton.transform = CGAffineTransform.identity
            }
        }
    }
}

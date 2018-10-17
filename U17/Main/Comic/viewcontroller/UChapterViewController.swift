//
//  UChapterViewController.swift
//  U17
//
//  Created by Leo on 2018/8/29.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UChapterViewController: UBaseViewController {
    private var isPositive: Bool = true
    var detailStatic: DetailStaticModel?
    var detailRealtime: DetailRealtimeModel?
    weak var delegate: UComicViewWillEndDraggingDelegate?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: floor((SCREEN_WIDTH - 30)/2), height: 40)
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(supplementaryViewType: UChapterCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(cellType: UChapterCCell.self)
        return cw
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    func reloadData(){
    collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension UChapterViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailStatic?.chapter_list?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UChapterCHead.self)
        head.model = detailStatic
        head.setClosure { [weak self] (button) in
            if self?.isPositive == true{
                self?.isPositive = false
                button.setTitle("正序", for: .normal)
            }else{
                self?.isPositive = true
                button.setTitle("到序", for: .normal)
            }
            self?.collectionView.reloadData()
        }
        return head
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UChapterCCell.self)
        if isPositive {
            cell.chaptModel = detailStatic?.chapter_list?[indexPath.row]
        }else{
            cell.chaptModel = detailStatic?.chapter_list?.reversed()[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = isPositive ? indexPath.row : ((detailStatic?.chapter_list?.count)! - indexPath.row - 1)
        let vc = UReadViewController(detailStatic: detailStatic ,selectIndex: index)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

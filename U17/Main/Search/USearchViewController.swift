//
//  USearchViewController.swift
//  U17
//
//  Created by Leo on 2018/9/21.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import Moya
class USearchViewController: UBaseViewController {
    
    private var  hotItems: [SearchItemModel]?
    private var relative: [SearchItemModel]?
    private var comics: [ComicModel]?
    private var currentRequest: Cancellable?
    private lazy var searchHistory: [String]! = {
        return UserDefaults.standard.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
    }()
    private lazy var search: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.textColor = UIColor.gray
        tf.tintColor = UIColor.darkGray
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.placeholder = "输入漫画名称/作者"
        tf.layer.cornerRadius = 15
        tf.clearsOnBeginEditing = true
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .search
        tf.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(not:)), name: .UITextFieldTextDidChange, object: tf)
        return tf
    }()
    private lazy var historyTableView: UITableView = {
        let tw = UITableView(frame: CGRect.zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: UBaseTableViewCell.self)
        tw.register(headerFooterViewType: USearchTHead.self)
        tw.register(headerFooterViewType: USearchTFoot.self)
        return tw
    }()
    private lazy var searchTableView: UITableView = {
        let st = UITableView(frame: CGRect.zero, style: .grouped)
        st.dataSource = self
        st.delegate = self
        st.register(headerFooterViewType: USearchTHead.self)
        st.register(cellType: UBaseTableViewCell.self)
        return st
    }()
    private lazy var resultTableView: UITableView = {
        let  rt = UITableView(frame: CGRect.zero, style: .grouped)
        rt.dataSource = self
        rt.delegate = self
        rt.register(cellType: UComicTCell.self)
        return rt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func loadHistory(){
        historyTableView.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        ApiLoadingProvider.request(API.searchHot, model: HotItemsModel.self) { [weak self] (data) in
            self?.hotItems = data?.hotItems
            self?.historyTableView.reloadData()
        }
    }
    override func configUI() {
        view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        search.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 50, height: 30)
        navigationItem.titleView = search
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", target: self, action: #selector(cancelAction))
    }
    @objc func cancelAction(){
        search.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    func searchRelative(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = false
            resultTableView.isHidden = true
            currentRequest?.cancel()
            currentRequest = ApiProvider.request(API.searchRelative(inputText: text), model: [SearchItemModel].self, completion: {[weak self] (data) in
                self?.relative = data
                self?.searchTableView.reloadData()
            })
        }else{
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
            UNoticeBar(config: UNoticeBarConfig(title: "暂无搜索结果", barStyle: .onNavigationBar, animationType: .top)).show(duration: 2);
        }
    }
     ///
    /// 收到textfield的变化
    ///
    /// - Parameter not: 描述
    @objc func textFiledTextDidChange(not: NSNotification){
        guard let textField = not.object as? UITextField, let text = textField.text else { return  }
        searchRelative(text)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension USearchViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTableView {
            return 2
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return section == 0 ? (searchHistory?.prefix(5).count ?? 0) : 0;
        }else if tableView == searchTableView {
            return self.relative?.count ?? 0
        }else {
            return comics?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 100
        }else {
            return 44
        }
    }
    
}

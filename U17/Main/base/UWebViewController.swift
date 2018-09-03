//
//  UWebViewController.swift
//  U17
//
//  Created by Leo on 2018/8/29.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import WebKit
class UWebViewController: UBaseViewController {
    var request: URLRequest!
    lazy var webview: WKWebView = {
        let wk = WKWebView()
        wk.allowsBackForwardNavigationGestures = true
        wk.navigationDelegate = self
        wk.uiDelegate = self
        return wk
    }()
    lazy var progressView: UIProgressView = {
        let pw = UIProgressView()
        pw.trackImage = UIImage.init(named: "nav_bg")
        pw.progressTintColor = UIColor.white
        return pw
    }()
    convenience init(url: String?) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.load(request)
    }
    override func configUI() {
        view.addSubview(webview)
        webview.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
        view.addSubview(progressView)
        progressView.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"),
                                                           target: self,
                                                           action: #selector(reload))
    }
    @objc func reload(){
        webview.reloadFromOrigin()
    }
    override func pressBack() {
        if webview.canGoBack {
            webview.goBack()
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    deinit {
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UWebViewController: WKNavigationDelegate,WKUIDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webview.estimatedProgress >= 1
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}

//
//  ServiceWebViewController.swift
//  E-HAUT
//
//  Created by zh on 2019/6/9.
//  Copyright © 2019 ehaut. All rights reserved.
//  See here: https://www.jianshu.com/p/d29384454a9a
//  And here: https://stackoverflow.com/questions/49638653/load-local-web-files-resources-in-wkwebview

import UIKit
import WebKit

class ServiceWebViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView:WKWebView?
    var progBar = UIProgressView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取导航栏高度
        let navHeight = self.navigationController?.navigationBar.frame.height
        //获取状态栏高度
        let statusHeight = UIApplication.shared.statusBarFrame.height
        webView = WKWebView(frame: CGRect(x: 0, y: statusHeight+navHeight!,width: self.view.frame.width, height: self.view.frame.height))
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        let url = Bundle.main.url(forResource: "service", withExtension: "html", subdirectory: "web")!
        webView?.loadFileURL(url, allowingReadAccessTo: url)
        //创建请求
        let request = NSURLRequest(url: url)
        //加载请求
        webView?.load(request as URLRequest)
        //添加wkwebview
        self.view.addSubview(webView!)
        setNavBar()
        //以下代码添加到viewDidLoad()
        progBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        progBar.progress = 0.0
        progBar.tintColor = UIColor.blue
        self.webView?.addSubview(progBar)
        self.webView?.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
    }
 
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(webView!.estimatedProgress), animated: true)
            //进度条的值最大为1.0
            let value:Double = self.webView!.estimatedProgress
            if(value >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in
                    self.progBar.alpha = 0.0
                }, completion: { (finished:Bool) -> Void in
                    self.progBar.progress = 0
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = self.webView?.title
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //如果目标主视图不为空,则允许导航
        if !(navigationAction.targetFrame?.isMainFrame != nil) {
            self.webView?.load(navigationAction.request)
        }
        return nil
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    var btnBack = UIBarButtonItem()
    var btnRefresh = UIBarButtonItem()
    func setNavBar() {
        btnBack = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("toBack")))
        btnRefresh = UIBarButtonItem(title: "刷新", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("toRefresh")))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.rightBarButtonItem = btnRefresh
    }
    @objc func toBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toRefresh() {
        webView?.reload()
    }
}

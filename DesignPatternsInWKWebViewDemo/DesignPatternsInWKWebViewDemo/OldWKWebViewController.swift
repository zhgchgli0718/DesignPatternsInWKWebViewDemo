//
//  OldWKWebViewController.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import UIKit
import WebKit
import Foundation

/// 舊的完全沒抽象的 WKWebView
class OldWKWebViewController: UIViewController {

    // 模擬商業邏輯：開關 Match 特殊路徑開原生頁面
    private let noNeedNativePresent: Bool
    // 模擬商業邏輯：開關 DeeplinkManager 檢查
    private let deeplinkCheck: Bool
    // 模擬商業邏輯：是開首頁嗎？
    private let isHomePage: Bool
    // 模擬商業邏輯：要注入到 WKWebView 的 WKUserScript 的腳本
    private let userScripts: [WKUserScript]
    // 模擬商業邏輯：要注入到 WKWebView 的 WKScriptMessageHandler 的腳本
    private let scriptMessageHandlers: [String: WKScriptMessageHandler]
    // 是否允許從 WebView 取得 Title 複寫 ViewController Title
    private let overrideTitleFromWebView: Bool
    
    private let url: URL
    
    init(noNeedNativePresent: Bool = false,
         deeplinkCheck: Bool = false,
         isHomePage: Bool = false,
         userScripts: [WKUserScript] = [],
         scriptMessageHandlers: [String: WKScriptMessageHandler] = [:],
         overrideTitleFromWebView: Bool = true,
         url: URL) {
        self.noNeedNativePresent = noNeedNativePresent
        self.deeplinkCheck = deeplinkCheck
        self.isHomePage = isHomePage
        self.userScripts = userScripts
        self.scriptMessageHandlers = scriptMessageHandlers
        self.overrideTitleFromWebView = overrideTitleFromWebView
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var webView = makeWebView()
    private lazy var progressView = makeProgressView()

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        scriptMessageHandlers.forEach { (key, value) in
            webView.configuration.userContentController.add(value, name: key)
        }
        userScripts.forEach { userScript in
            webView.configuration.userContentController.addUserScript(userScript)
        }
        
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func load(urlRequest: URLRequest) {
        webView.load(urlRequest)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.progressView.alpha = 0.0
                })
            } else {
                progressView.alpha = 1.0
            }
        }
    }
}

extension OldWKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        // 模擬商業邏輯：WebViewController deeplinkCheck == true (代表需要過 DeepLinkManager 檢查並開啟頁面)
        if deeplinkCheck {
            print("DeepLinkManager.open(\(url.absoluteString)")
            // 模擬 DeepLinkManager 邏輯，URL 能成功打開則打開並結束流程。
            // if DeepLinkManager.open(url) == true {
                decisionHandler(.cancel)
                return
            // }
        }
        
        // 模擬商業邏輯：WebViewController isHomePage == true (代表是開主頁) & WebView 正在瀏覽首頁，則切換 TabBar Index
        if isHomePage {
            if url.absoluteString == "https://zhgchg.li" {
                print("Switch UITabBarController to Index 0")
                decisionHandler(.cancel)
            }
        }
        
        // 模擬商業邏輯：WebViewController noNeedNativePresent == false (代表需要 Match 特殊路徑開原生頁面)
        if !noNeedNativePresent {
            if url.pathComponents.count >= 3 {
                if url.pathComponents[1] == "product" {
                    // match http://zhgchg.li/product/1234
                    let id = url.pathComponents[2]
                    print("Present ProductViewController(\(id)")
                    decisionHandler(.cancel)
                } else if url.pathComponents[1] == "shop" {
                    // match http://zhgchg.li/shop/1234
                    let id = url.pathComponents[2]
                    print("Present ShopViewController(\(id)")
                    decisionHandler(.cancel)
                }
                // more...
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if overrideTitleFromWebView {
            self.title = webView.title
        }
    }
}

private extension OldWKWebViewController {
    func setupUI() {
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func makeWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }
    
    func makeProgressView() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = UIColor(red: 38/255.0, green: 190/255.0, blue: 201/255.0, alpha: 1.0)
        progressView.trackTintColor = .lightGray
        
        return progressView
    }
}



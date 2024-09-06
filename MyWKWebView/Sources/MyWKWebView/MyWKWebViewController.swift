//
//  MyWKWebViewController.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/8/31.
//

import UIKit
import WebKit
import Foundation

public class MyWKWebViewController: UIViewController {
    
    private lazy var webView = makeWebView()
    private lazy var progressView = makeProgressView()
    private let configuration: MyWKWebViewConfiguration
    
    public init(configuration: MyWKWebViewConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        webView.load(URLRequest(url: configuration.url))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        configuration.scriptMessageStrategies.forEach { scriptMessageStrategy in
            webView.configuration.userContentController.add(scriptMessageStrategy, name: type(of: scriptMessageStrategy).identifier)
        }
        
        configuration.userScripts.forEach { userScript in
            webView.configuration.userContentController.addUserScript(userScript)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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

extension MyWKWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        configuration.headNavigationHandler?.exeute(webView: webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) ?? decisionHandler(.allow)
    }
}

private extension MyWKWebViewController {
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


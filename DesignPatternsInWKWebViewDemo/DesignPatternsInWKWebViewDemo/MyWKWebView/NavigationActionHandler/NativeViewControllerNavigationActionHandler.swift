//
//  NativeViewControllerNavigationActionHandler.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

final class NativeViewControllerNavigationActionHandler: NavigationActionHandler {
    var nextHandler: NavigationActionHandler?
    
    func handle(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool {
        guard let url = navigationAction.request.url else {
            return false
        }
        
        // 模擬商業邏輯：需要 Match 特殊路徑開原生頁面
        guard url.pathComponents.count >= 3 else {
            return false
        }

        if url.pathComponents[1] == "product" {
            // match http://zhgchg.li/product/1234
            let id = url.pathComponents[2]
            print("Present ProductViewController(\(id)")
            decisionHandler(.cancel)
            return true
        } else if url.pathComponents[1] == "shop" {
            // match http://zhgchg.li/shop/1234
            let id = url.pathComponents[2]
            print("Present ShopViewController(\(id)")
            decisionHandler(.cancel)
            return true
        } else {
            return false
        }
    }
}


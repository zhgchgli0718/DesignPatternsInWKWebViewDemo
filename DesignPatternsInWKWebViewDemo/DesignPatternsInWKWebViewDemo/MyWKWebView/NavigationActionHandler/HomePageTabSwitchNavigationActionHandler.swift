//
//  HomePageTabSwitchNavigationActionHandler.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

final class HomePageTabSwitchNavigationActionHandler: NavigationActionHandler {
    var nextHandler: NavigationActionHandler?
    
    func handle(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool {
        guard let url = navigationAction.request.url else {
            return false
        }
        
        // 模擬商業邏輯：WebView 正在瀏覽首頁，則切換 TabBar Index
        guard url.absoluteString == "https://zhgchg.li" else {
            return false
        }
        
        print("Switch UITabBarController to Index 0")
        decisionHandler(.cancel)
        return true
    }
}

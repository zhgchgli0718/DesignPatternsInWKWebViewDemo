//
//  DeeplinkManagerNavigationActionHandler.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

final class DeeplinkManagerNavigationActionHandler: NavigationActionHandler {
    var nextHandler: NavigationActionHandler?
    
    func handle(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool {
        guard let url = navigationAction.request.url else {
            return false
        }
        
        
        // 模擬 DeepLinkManager 邏輯，URL 能成功打開則打開並結束流程。
        // if DeepLinkManager.open(url) == true {
            decisionHandler(.cancel)
            return true
        // } else {
            return false
        //
    }
}

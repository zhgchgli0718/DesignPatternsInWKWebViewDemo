//
//  PaymentNavigationActionHandler.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

final class PaymentNavigationActionHandler: NavigationActionHandler {
    var nextHandler: NavigationActionHandler?
    
    func handle(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool {
        guard let url = navigationAction.request.url else {
            return false
        }
        
        // 模擬商業邏輯：Payment 付款相關、兩階段驗證 WebView...etc
        print("Present Payment Verify View Controller")
        decisionHandler(.cancel)
        return true
    }
}



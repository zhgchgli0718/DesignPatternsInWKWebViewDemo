//
//  DefaultNavigationActionHandler.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

public final class DefaultNavigationActionHandler: NavigationActionHandler {
    public var nextHandler: NavigationActionHandler?
    
    public init() {
        
    }
    
    public func handle(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool {
        decisionHandler(.allow)
        return true
    }
}



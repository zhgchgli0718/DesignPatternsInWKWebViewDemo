//
//  File.swift
//  
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import WebKit

public protocol NavigationActionHandler: AnyObject {
    var nextHandler: NavigationActionHandler? { get set }

    /// Handles navigation actions for the web view. Returns true if the action was handled, otherwise false.
    func handle(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Bool
    /// Executes the navigation action policy decision. If the current handler does not handle it, the next handler in the chain will be executed.
    func exeute(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
}

public extension NavigationActionHandler {
    func exeute(webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if !handle(webView: webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) {
            self.nextHandler?.exeute(webView: webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) ?? decisionHandler(.allow)
        }
    }
}

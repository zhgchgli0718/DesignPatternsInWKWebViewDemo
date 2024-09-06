//
//  UserScriptMessageStrategy.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

final class UserScriptMessageStrategy: NSObject, ScriptMessageStrategy {
    static var identifier: String = "user"
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // called from js: window.webkit.messageHandlers.user.postMessage("Hello");
        print("\(Self.identifier): \(message.body)")
    }
}

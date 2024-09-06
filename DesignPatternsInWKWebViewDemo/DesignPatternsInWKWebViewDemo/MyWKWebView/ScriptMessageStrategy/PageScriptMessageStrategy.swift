//
//  PageScriptMessageStrategy.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

final class PageScriptMessageStrategy: NSObject, ScriptMessageStrategy {
    static var identifier: String = "page"
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // called from js: window.webkit.messageHandlers.page.postMessage("Close");
        print("\(Self.identifier): \(message.body)")
    }
}

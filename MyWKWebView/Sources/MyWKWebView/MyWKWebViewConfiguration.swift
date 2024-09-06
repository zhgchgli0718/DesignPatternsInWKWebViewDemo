//
//  MyWKWebViewConfiguration.swift
//
//
//  Created by zhgchgli on 2024/8/31.
//

import Foundation
import WebKit


/// 只有 Internal 可以 init
public struct MyWKWebViewConfiguration {
    let headNavigationHandler: NavigationActionHandler?
    let scriptMessageStrategies: [ScriptMessageStrategy]
    let userScripts: [WKUserScript]
    let overrideTitleFromWebView: Bool
    let url: URL
}

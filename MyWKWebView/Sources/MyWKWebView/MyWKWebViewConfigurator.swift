//
//  MyWKWebViewConfigurator.swift
//
//
//  Created by zhgchgli on 2024/8/31.
//

import Foundation
import WebKit

public final class MyWKWebViewConfigurator {
    
    private var headNavigationHandler: NavigationActionHandler? = nil
    private var overrideTitleFromWebView: Bool = true
    private var disableZoom: Bool = false
    private var scriptMessageStrategies: [ScriptMessageStrategy] = []
    
    public init() {
        
    }
    
    public func set(disableZoom: Bool) -> Self {
        self.disableZoom = disableZoom
        return self
    }
    
    public func set(overrideTitleFromWebView: Bool) -> Self {
        self.overrideTitleFromWebView = overrideTitleFromWebView
        return self
    }
    
    public func set(headNavigationHandler: NavigationActionHandler) -> Self {
        self.headNavigationHandler = headNavigationHandler
        return self
    }
    
    // 可以把新增邏輯規則封裝在裡面
    public func add(scriptMessageStrategy: ScriptMessageStrategy) -> Self {
        scriptMessageStrategies.removeAll(where: { type(of: $0).identifier == type(of: scriptMessageStrategy).identifier })
        scriptMessageStrategies.append(scriptMessageStrategy)
        return self
    }
    
    public func build(url: URL) -> MyWKWebViewConfiguration {
        var userScripts:[WKUserScript] = []
        if disableZoom {
            let script = "var meta = document.createElement('meta'); meta.name='viewport'; meta.content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; document.getElementsByTagName('head')[0].appendChild(meta);"
            let disableZoomScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userScripts.append(disableZoomScript)
        }
        
        return MyWKWebViewConfiguration(headNavigationHandler: headNavigationHandler, scriptMessageStrategies: scriptMessageStrategies, userScripts: userScripts, overrideTitleFromWebView: overrideTitleFromWebView, url: url)
    }
}

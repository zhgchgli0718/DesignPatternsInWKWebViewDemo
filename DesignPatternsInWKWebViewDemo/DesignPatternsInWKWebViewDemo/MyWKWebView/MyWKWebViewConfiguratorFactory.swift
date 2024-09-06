//
//  MyWKWebViewConfiguratorFactory.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/9/5.
//

import Foundation
import MyWKWebView
import WebKit

struct MyWKWebViewConfiguratorFactory {
    enum ForType {
        case `default`
        case productPage
        case payment
    }
    
    static func make(for type: ForType) -> MyWKWebViewConfigurator {
        switch type {
        case .default:
            
            let deplinkManagerNavigationActionHandler = DeeplinkManagerNavigationActionHandler()
            let homePageTabSwitchNavigationActionHandler = HomePageTabSwitchNavigationActionHandler()
            let nativeViewControllerNavigationActionHandlera = NativeViewControllerNavigationActionHandler()
            let defaultNavigationActionHandler = DefaultNavigationActionHandler()
            
            deplinkManagerNavigationActionHandler.nextHandler = homePageTabSwitchNavigationActionHandler
            homePageTabSwitchNavigationActionHandler.nextHandler = nativeViewControllerNavigationActionHandlera
            nativeViewControllerNavigationActionHandlera.nextHandler = defaultNavigationActionHandler
            
            return MyWKWebViewConfigurator()
                .add(scriptMessageStrategy: PageScriptMessageStrategy())
                .add(scriptMessageStrategy: UserScriptMessageStrategy())
                .set(headNavigationHandler: deplinkManagerNavigationActionHandler)
                .set(overrideTitleFromWebView: false)
                .set(disableZoom: false)
        case .productPage:
            return Self.make(for: .default).set(disableZoom: true).set(overrideTitleFromWebView: true)
        case .payment:
            let paymentNavigationActionHandler = PaymentNavigationActionHandler()
            let deplinkManagerNavigationActionHandler = DeeplinkManagerNavigationActionHandler()
            let defaultNavigationActionHandler = DefaultNavigationActionHandler()
            
            paymentNavigationActionHandler.nextHandler = deplinkManagerNavigationActionHandler
            deplinkManagerNavigationActionHandler.nextHandler = defaultNavigationActionHandler
            
            return MyWKWebViewConfigurator().set(headNavigationHandler: paymentNavigationActionHandler)
        }
    }
}

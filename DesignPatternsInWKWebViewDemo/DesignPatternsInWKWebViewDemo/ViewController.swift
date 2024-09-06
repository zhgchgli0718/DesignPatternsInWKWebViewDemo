//
//  ViewController.swift
//  DesignPatternsInWKWebViewDemo
//
//  Created by zhgchgli on 2024/8/31.
//

import UIKit
import MyWKWebView

class ViewController: UIViewController {
    enum ProductType {
        case normal
        case esim
        case hotel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func openProductPage(productType: ProductType, id: String) {
        let configurator = MyWKWebViewConfiguratorFactory.make(for: .productPage)
        let configuration: MyWKWebViewConfiguration
        
        switch productType {
        case .normal:
            configuration = configurator.build(url: URL(string: "https://zhgchg.li/product/\(id)/")!)
        case .esim:
            configuration = configurator.build(url: URL(string: "https://zhgchg.li/esim/\(id)/")!)
        case .hotel:
            configuration = configurator.build(url: URL(string: "https://zhgchg.li/hotel/\(id)/")!)
        }
        
        self.present(MyWKWebViewController(configuration: configuration), animated: true)
    }
    
    func openURL(url: URL) {
        let configurator = MyWKWebViewConfiguratorFactory.make(for: .default)
        let configuration = configurator.build(url: url)
        self.present(MyWKWebViewController(configuration: configuration), animated: true)
    }

}


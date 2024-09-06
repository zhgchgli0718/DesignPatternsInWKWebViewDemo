//
//  ScriptMessageStrategy.swift
//
//
//  Created by zhgchgli on 2024/9/1.
//

import Foundation
import WebKit

public protocol ScriptMessageStrategy: NSObject, WKScriptMessageHandler {
    static var identifier: String { get }
}


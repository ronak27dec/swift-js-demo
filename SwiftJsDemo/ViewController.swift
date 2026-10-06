//
//  ViewController.swift
//  SwiftJsDemo
//
//  Created by Ronak Malick on 19/12/25.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserContentController()

        loadHTML()
    }

    private func configureUserContentController() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "iosListener")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
    }

    private func loadHTML() {
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }

    private func sendMessageToJS(_ message: String) {
        let jsCode = "receiveFromSwift('\(message)')"
        webView.evaluateJavaScript(jsCode) { _, error in
            if error == nil {
                print("SUCCESS - Message successfully send to JS")
            }
        }
    }
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        if message.name == "iosListener" {
            print("Received message from JS: \(message.body)")
            sendMessageToJS("Hello, this is a message from iOS to Js")
        }
    }
}

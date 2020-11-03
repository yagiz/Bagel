//
//  CodeMirrorWebView.swift
//  NSProxy
//
//  Created by Nghia Tran on 4/26/20.
//  Copyright © 2020 com.nsproxy.proxy. All rights reserved.
//

import Foundation
import WebKit

#if os(OSX)
    import AppKit
    typealias View = NSView
#elseif os(iOS)
    import UIKit
    typealias View = UIView
#endif

private extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

// MARK: CodeMirrorWebViewDelegate

protocol CodeMirrorWebViewDelegate: class {

    func codeMirrorViewDidLoadSuccess(_ sender: CodeMirrorWebView)
    func codeMirrorViewDidLoadError(_ sender: CodeMirrorWebView, error: Error)
    func codeMirrorViewDidChangeContent(_ sender: CodeMirrorWebView, content: String)
}

// MARK: JavascriptFunction

// JS Func
typealias JavascriptCallback = (Result<Any?, Error>) -> Void
private struct JavascriptFunction {

    let functionString: String
    let callback: JavascriptCallback?

    init(functionString: String, callback: JavascriptCallback? = nil) {
        self.functionString = functionString
        self.callback = callback
    }
}

// MARK: CodeMirrorWebView

final class CodeMirrorWebView: View {

    private struct Constants {
        static let codeMirrorDidReady = "codeMirrorDidReady"
        static let codeMirrorTextContentDidChange = "codeMirrorTextContentDidChange"
    }

    // MARK: Variables

    weak var delegate: CodeMirrorWebViewDelegate?
    private lazy var webview: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        var userController = WKUserContentController()
        userController.add(self, name: Constants.codeMirrorDidReady) // Callback from CodeMirror JS
        userController.add(self, name: Constants.codeMirrorTextContentDidChange)
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = userController
        let webView = WKWebView(frame: bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground") // Prevent white flick
        return webView
    }()

    private var pageLoaded = false
    private var pendingFunctions = [JavascriptFunction]()

    // MARK: Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initWebView()
        configCodeMirror()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initWebView()
        configCodeMirror()
    }

    // MARK: Properties

    func setTabInsertsSpaces(_ value: Bool) {
        callJavascript(javascriptString: "SetTabInsertSpaces(\(value));")
    }

    func setContent(_ value: String) {
        if let hexString = value.data(using: .utf8)?.hexEncodedString() {
            let script = """
            var content = "\(hexString)"; SetContent(content);
            """
            callJavascript(javascriptString: script)
        }
    }

    func getContent(_ block: JavascriptCallback?) {
        callJavascript(javascriptString: "GetContent();", callback: block)
    }

    func setMimeType(_ value: String) {
        callJavascript(javascriptString: "SetMimeType(\"\(value)\");")
    }

    func setThemeName(_ value: Bool) {
        callJavascript(javascriptString: "SetTheme(\"\(value)\");")
    }

    func setLineWrapping(_ value: Bool) {
        callJavascript(javascriptString: "SetLineWrapping(\(value));")
    }

    func setFontSize(_ value: Int) {
        callJavascript(javascriptString: "SetFontSize(\(value));")
    }

    func setDefaultTheme() {
        setMimeType("application/json")
    }

    func setReadonly(_ value: Bool) {
        callJavascript(javascriptString: "SetReadOnly(\(value));")
    }

    func getTextSelection(_ block: JavascriptCallback?) {
        callJavascript(javascriptString: "GetTextSelection();", callback: block)
    }
}

// MARK: Private

extension CodeMirrorWebView {

    private func initWebView() {
        webview.allowsMagnification = false
        webview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webview)
        webview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        webview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // Load CodeMirror bundle
        guard let bundlePath = Bundle.main.path(forResource: "CodeMirrorView", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath),
            let indexPath = bundle.path(forResource: "index", ofType: "html") else {
                fatalError("CodeMirrorBundle is missing")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: indexPath))
        webview.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bundle.resourceURL!)
    }

    private func configCodeMirror() {
        setTabInsertsSpaces(true)
    }

    private func addFunction(function:JavascriptFunction) {
        pendingFunctions.append(function)
    }

    private func callJavascriptFunction(function: JavascriptFunction) {
        webview.evaluateJavaScript(function.functionString) { (response, error) in
            if let error = error {
                function.callback?(.failure(error))
            }
            else {
                function.callback?(.success(response))
            }
        }
    }

    private func callPendingFunctions() {
        for function in pendingFunctions {
            callJavascriptFunction(function: function)
        }
        pendingFunctions.removeAll()
    }

    private func callJavascript(javascriptString: String, callback: JavascriptCallback? = nil) {
        if pageLoaded {
            callJavascriptFunction(function: JavascriptFunction(functionString: javascriptString, callback: callback))
        }
        else {
            addFunction(function: JavascriptFunction(functionString: javascriptString, callback: callback))
        }
    }
}

// MARK: WKNavigationDelegate

extension CodeMirrorWebView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.codeMirrorViewDidLoadSuccess(self)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.codeMirrorViewDidLoadError(self, error: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        delegate?.codeMirrorViewDidLoadError(self, error: error)
    }
}

// MARK: WKScriptMessageHandler

extension CodeMirrorWebView: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        // is Ready
        if message.name == Constants.codeMirrorDidReady {
            pageLoaded = true
            callPendingFunctions()
            return
        }

        // Content change
        if message.name == Constants.codeMirrorTextContentDidChange {
            let content = (message.body as? String) ?? ""
            delegate?.codeMirrorViewDidChangeContent(self, content: content)
        }
    }
}

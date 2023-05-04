//
//  ItemPreviewViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import WebKit

class ItemPreviewViewController: UIViewController {



    @IBOutlet weak var previewWebView: WKWebView!

    var model: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        previewWebView.navigationDelegate = self
        guard let model = model else { return }
        let url = URL(string: model.itemUrl)
        let request = URLRequest(url: url!)
        previewWebView.load(request)
    }

}

extension ItemPreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
                // リンクがタップされた時、遷移をキャンセルする
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
    }

}

//
//  ItemPreviewViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import WebKit
import RealmSwift

class ItemPreviewViewController: UIViewController {
    @IBOutlet private weak var previewWebView: WKWebView!
    private let realm = try! Realm()
    public var model: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        previewWebView.navigationDelegate = self
        guard let model = model else { return }
        let url = URL(string: model.itemUrl)
        let request = URLRequest(url: url!)
        previewWebView.load(request)
    }
    
    @IBAction func tapStaffButtonAction(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let vc = StoryboardScene.ChatViewController.initialScene.instantiate()
            let newChatList = ChatList()
            newChatList.name = self?.model?.itemName ?? ""
            newChatList.imageURL = self?.model?.mediumImageUrls.first?.imageUrl ?? ""
            self?.save(chatList: newChatList)
            vc.selectedChatList = newChatList
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func save(chatList: ChatList) {
        do {
            try realm.write {
                realm.add(chatList)
            }
        } catch {
            print("Error feching data from context \(error)")
        }
    }
}

extension ItemPreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}

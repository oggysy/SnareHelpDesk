//
//  ChatTableViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/05.
//

import UIKit
import RealmSwift

class ChatTableViewController: UIViewController {

    let realm = try! Realm()
    private var chatList: Results<ChatList>?

    @IBOutlet weak var chatListTableView: UITableView! {
        didSet{
            chatListTableView.register(UINib(nibName: "ChatTableViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewTableViewCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTableView.dataSource = self
        chatListTableView.delegate = self
        navigationItem.title = "チャット履歴"
        loadChatList()
    }

}

extension ChatTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatList?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewTableViewCell", for: indexPath) as? ChatTableViewTableViewCell ,let chatList = chatList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: chatList)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            let vc = StoryboardScene.ChatViewController.initialScene.instantiate()
            vc.selectedChatList = self?.chatList?[indexPath.row]
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
}

extension ChatTableViewController {

    private func loadChatList() {
        chatList = realm.objects(ChatList.self)
        chatListTableView.reloadData()
    }

}

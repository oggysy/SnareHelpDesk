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
    private var notificationToken: NotificationToken?

    @IBOutlet private weak var chatListTableView: UITableView! {
        didSet {
            chatListTableView.register(UINib(nibName: "ChatTableViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewTableViewCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTableView.dataSource = self
        chatListTableView.delegate = self
        navigationItem.title = "チャット履歴"
        loadChatList()
        notificationToken = chatList?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else {
                return
            }
            switch changes {
            case .initial:
                self.chatListTableView.reloadData()
            case .update:
                self.chatListTableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

}

extension ChatTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatList?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewTableViewCell", for: indexPath) as? ChatTableViewTableViewCell, let chatList = chatList?[indexPath.row] else {
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

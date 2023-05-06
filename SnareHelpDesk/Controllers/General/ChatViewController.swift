//
//  ChatViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/05.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift
import OpenAISwift


class ChatViewController: MessagesViewController {
    var messageList: Results<Message>?
    let realm = try! Realm()
    var selectedChatList: ChatList? {
        didSet{
            loadItems()
        }
    }

    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        navigationItem.title = selectedChatList?.name
        // チャット履歴が0の時に行う処理
        if messageList?.count == 0 {
            let promptMessage = createPrompt()
            save(with: promptMessage)
            sendMessageToChatGPT()
        }
        messagesCollectionView.reloadData()
    }



    private func loadItems() {
        messageList = selectedChatList?.chatHistory.sorted(byKeyPath: "sentDate", ascending: true)
        self.messagesCollectionView.reloadData()
    }
}


// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return userType.me.data
    }

    func otherSender() -> SenderType {
        return userType.you.data
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        guard let messageList = messageList else { return 0 }
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        if indexPath.section == 0 {
            return Message(messageId: UUID().uuidString, sender: userType.you.data, sentDate: Date(), kind: .text("お問い合わせありがとうございます"))
        }
        guard let messageList = messageList else { return Message()}
        return messageList[indexPath.section]
    }


    // メッセージの上に文字を表示（名前）
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}


extension ChatViewController: MessagesDisplayDelegate {

    // メッセージの色を変更
    func textColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .black : .white
    }

    // メッセージの背景色を変更している
    func backgroundColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .systemFill : .systemTeal
    }

    // メッセージの枠にしっぽを付ける
    func messageStyle(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    // アイコンをセット
    func configureAvatarView(
        _ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) {
        avatarView.set( avatar: message.sender.senderId == "001" ? Avatar(initials: "you") : Avatar(image: UIImage(named: "staff")))
    }
}



// 各ラベルの高さを設定（デフォルト0なので必須）
// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        indexPath.section % 3 == 0 ? 10 : 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        16
    }
}


extension ChatViewController: MessageCellDelegate {

    func didTapBackground(in cell: MessageCollectionViewCell) {
        closeKeyboard()
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        closeKeyboard()
    }

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        closeKeyboard()
    }

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        closeKeyboard()
    }

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        closeKeyboard()
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    // 送信ボタンをタップした時の挙動
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(messageId: UUID().uuidString, sender: currentSender as! Sender, sentDate: Date(), kind: .text(text))
                save(with: message)
                messagesCollectionView.reloadData()
                sendMessageToChatGPT()
        self.messageInputBar.inputTextView.text = String()
        self.messageInputBar.invalidatePlugins()
        self.messagesCollectionView.scrollToLastItem()
    }
}

extension ChatViewController {
    func closeKeyboard(){
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.messagesCollectionView.scrollToLastItem()
    }

    func save(with message: Message) {
        do {
            try realm.write {
                guard let selectedChatList = selectedChatList else { return }
                selectedChatList.chatHistory.append(message)
            }
        } catch {
            print("Error saving message: \(error)")
        }
    }

    func createPrompt() -> Message {
        guard let item = selectedChatList else { return Message() }
        let itemName = item.name
        let prompt = "あなたは楽器店の店員でスネア販売担当をしています。\(itemName)について教えてください。また最初の返答は\(itemName)についてどんなことを聞きたいですか？と返してください"
        let promptMessage = Message(messageId: UUID().uuidString, sender: userType.system.data, sentDate: Date(), kind: .text(prompt))
        return promptMessage
    }

    func sendMessageToChatGPT() {
        let messagesArray: [Message] = Array(messageList!)
        let chatMessages = Message.convertToChatMessage(with: messagesArray)
        Task.init {
            let result = try await APICaller.shared.generatedAnswer(from:chatMessages)
            let gptmessage = Message(messageId: UUID().uuidString, sender: otherSender() as! Sender, sentDate: Date(), kind: .text(result))
            save(with: gptmessage)
            messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
}

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
    private var messageList: Results<Message>?
    private let realm = try! Realm()
    public var selectedChatList: ChatList? {
        didSet {
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
        if messageList?.isEmpty ?? true {
            let promptMessage = createPrompt()
            save(with: promptMessage)
            sendMessageToChatGPT()
        }
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem()
        }

    }

    private func loadItems() {
        messageList = selectedChatList?.chatHistory.sorted(byKeyPath: "sentDate", ascending: true)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem()
        }
    }
}

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return UserType.me.data
    }

    func otherSender() -> SenderType {
        return UserType.you.data
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        guard let messageList = messageList else {
            return 0
        }
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        if indexPath.section == 0 {
            return Message(messageId: UUID().uuidString, sender: UserType.you.data, sentDate: Date(), kind: .text("お問い合わせありがとうございます"))
        }
        guard let messageList = messageList else {
            return Message()
        }
        return messageList[indexPath.section]
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func textColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .black : .white
    }

    func backgroundColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .systemFill : .systemTeal
    }

    func messageStyle(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    func configureAvatarView(
        _ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) {
        avatarView.set( avatar: message.sender.senderId == "001" ? Avatar(initials: "you") : Avatar(image: UIImage(named: "staff")))
    }
}

extension ChatViewController: MessagesLayoutDelegate {
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
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(messageId: UUID().uuidString, sender: currentSender as! Sender, sentDate: Date(), kind: .text(text))
        save(with: message)
        messagesCollectionView.reloadData()
        sendMessageToChatGPT()
        DispatchQueue.main.async {
            self.messageInputBar.inputTextView.text = String()
            self.messageInputBar.invalidatePlugins()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
}

extension ChatViewController {
    private func closeKeyboard() {
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.messagesCollectionView.scrollToLastItem()
    }

    private func save(with message: Message) {
        do {
            try realm.write {
                guard let selectedChatList = selectedChatList else {
                    return
                }
                selectedChatList.chatHistory.append(message)
            }
        } catch {
            print("Error saving message: \(error)")
        }
    }

    private func createPrompt() -> Message {
        guard let item = selectedChatList else {
            return Message()
        }
        let itemName = item.name
        let prompt = "あなたは楽器店の店員でスネア販売担当をしています。\(itemName)について教えてください。また最初の返答は\(itemName)についてどんなことを聞きたいですか？と返してください"
        let promptMessage = Message(messageId: UUID().uuidString, sender: UserType.system.data, sentDate: Date(), kind: .text(prompt))
        return promptMessage
    }

    private func sendMessageToChatGPT() {
        let messagesArray: [Message] = Array(messageList!)
        let chatMessages = Message.convertToChatMessage(with: messagesArray)
        Task.init {
            let result = try await APICaller.shared.generatedAnswer(from: chatMessages)
            let gptmessage = Message(messageId: UUID().uuidString, sender: otherSender() as! Sender, sentDate: Date(), kind: .text(result))
            save(with: gptmessage)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
}

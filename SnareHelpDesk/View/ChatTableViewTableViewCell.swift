//
//  ChatTableViewTableViewCell.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/05.
//

import UIKit

class ChatTableViewTableViewCell: UITableViewCell {

    @IBOutlet weak var chatIconImageView: UIImageView!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var chatCurrentMessageLabel: UILabel!

    func configure(with chatList: ChatList) {
        chatTitleLabel.text = chatList.name
        chatCurrentMessageLabel.text = chatList.chatHistory.last?.textContent
        guard let url = URL(string: chatList.imageURL) else {
            return
        }
        chatIconImageView.sd_setImage(with: url)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatIconImageView.layer.masksToBounds = false
        chatIconImageView.layer.cornerRadius = 30
        chatIconImageView.clipsToBounds = true
        chatIconImageView.layer.borderWidth = 2
        chatIconImageView.layer.borderColor = UIColor.systemCyan.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

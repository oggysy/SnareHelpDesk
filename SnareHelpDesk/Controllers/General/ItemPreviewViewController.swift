//
//  ItemPreviewViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import SDWebImage
import RealmSwift

class ItemPreviewViewController: UIViewController {
    private let realm = try! Realm()
    public var model: Item?


    @IBOutlet weak var itemDetailImageView: UIImageView!
    @IBOutlet weak var itemDetailNameLabel: UILabel!
    @IBOutlet weak var itemCaptionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = model else { return }
        itemDetailNameLabel.text = model.itemName
        itemCaptionLabel.text = model.itemCaption
        guard let resizeUrl = model.mediumImageUrls.first?.imageUrl.replacingOccurrences(of: "_ex=128x128", with: "_ex=300x300") ,let url = URL(string: resizeUrl) else { return }
        itemDetailImageView.sd_setImage(with: url, completed: nil)
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



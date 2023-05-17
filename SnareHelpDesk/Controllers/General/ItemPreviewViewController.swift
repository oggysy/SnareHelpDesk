//
//  ItemPreviewViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import RealmSwift

class ItemPreviewViewController: UIViewController {
    private let realm = try! Realm()
    public var model: Item?
    public var imageURL: [String] {
        guard let model = model else {
            return [String]()
        }
        return model.mediumImageUrls.map { $0.imageUrl.replacingOccurrences(of: "_ex=128x128", with: "_ex=300x300") }
    }

    @IBOutlet weak var itemImageCollectionView: UICollectionView! {
        didSet {
            let nibFiles = [
                "ItemImageCollectionViewCell"
            ]
            nibFiles.forEach { nibFile in
                itemImageCollectionView.register(UINib(nibName: nibFile, bundle: nil), forCellWithReuseIdentifier: nibFile)
            }
        }
    }

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = model else {
            return
        }
        itemNameLabel.text = model.itemName
        shopNameLabel.text = "ショップ名:\(model.shopName)"
        priceLabel.text = "価格:\(String(model.itemPriceMin3))円"
        captionLabel.text = "商品説明\n\(model.itemCaption)"

        itemImageCollectionView.delegate = self
        itemImageCollectionView.dataSource = self
        self.updateLayout()

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

    private func updateLayout() {
        let layout = CarouselCollectionViewFlowLayout()
        let collectionViewSize = itemImageCollectionView.frame.size
        let cellInsets = UIEdgeInsets(top: 0.0, left: ItemImageCollectionViewCell.widthInset, bottom: 0.0, right: ItemImageCollectionViewCell.widthInset)

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.sectionInset = cellInsets
        let layoutWidth = collectionViewSize.width - ItemImageCollectionViewCell.widthInset * 2
        let layoutHeight = layoutWidth * ItemImageCollectionViewCell.cellHeight / ItemImageCollectionViewCell.cellWidth
        layout.itemSize = CGSize(width: layoutWidth, height: layoutHeight)
        itemImageCollectionView.collectionViewLayout = layout
    }
}

extension ItemPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURL.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionViewCell", for: indexPath) as? ItemImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURL[indexPath.row])
        return cell
    }
}

final class CarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        let pageWidth = itemSize.width + minimumLineSpacing
        let currentPage = collectionView.contentOffset.x / pageWidth

        if abs(velocity.x) > 0.2 {
            let nextPage = (velocity.x > 0) ? ceil(currentPage) : floor(currentPage)
            return CGPoint(x: nextPage * pageWidth, y: proposedContentOffset.y)
        } else {
            return CGPoint(x: round(currentPage) * pageWidth, y: proposedContentOffset.y)
        }
    }
}

//
//  TitleCollectionViewCell.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {

    static let identifier = "TitleCollectionViewCell"

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!

    public func configure(with item: Item) {
        guard let urlString = item.mediumImageUrls.first?.imageUrl, let url = URL(string: urlString) else {
            return
        }
        itemImageView.sd_setImage(with: url, completed: nil)
        itemNameLabel.text = item.itemName
    }
}

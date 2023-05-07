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

    public func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        itemImageView.sd_setImage(with: url, completed: nil)
    }
}

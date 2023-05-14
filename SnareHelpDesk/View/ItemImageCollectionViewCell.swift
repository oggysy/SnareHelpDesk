//
//  ItemImageCollectionViewCell.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/11.
//

import UIKit
import SDWebImage

class ItemImageCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var ItemCellImageView: UIImageView!

    static let widthInset: CGFloat = 20.0
    static let cellWidth: CGFloat = 300
    static let cellHeight: CGFloat = 300

    func configure(with itemImageURL: String) {
        guard let url = URL(string: itemImageURL) else {
            return
        }
        ItemCellImageView.sd_setImage(with: url)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}

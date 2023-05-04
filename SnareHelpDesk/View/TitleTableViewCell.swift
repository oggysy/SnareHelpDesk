//
//  TitleTableViewCell.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit

class TitleTableViewCell: UITableViewCell {


    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!


    func configure(with item:ItemElement) {
        itemLabel.text = item.Item.itemName
        guard let url = URL(string: item.Item.mediumImageUrls.first?.imageUrl ?? "") else {
            return
        }
        itemImageView.sd_setImage(with: url)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  CollectionViewTableViewCell.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: Item)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "CollectionViewTableViewCell"
    private var items: [ItemElement] = [ItemElement]()
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let view = UINib(nibName: "CollectionViewTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! UITableViewCell
        contentView.addSubview(view)
        collectionView.register(UINib(nibName: TitleCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with items: [ItemElement]) {
        self.items = items
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CollectionViewTableViewCell :UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let urlString = items[indexPath.row].Item.mediumImageUrls.first?.imageUrl else {
            return UICollectionViewCell()
        }
        cell.configure(with: urlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = items[indexPath.row].Item
        self.delegate?.collectionViewTableViewCellDidTapCell(self, model: title)
    }
    
}

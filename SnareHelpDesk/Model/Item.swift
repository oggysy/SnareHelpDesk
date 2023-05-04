//
//  Item.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import Foundation
// MARK: - Result
struct ResultItems :Codable{
    let Items: [ItemElement]
}

// MARK: - ItemElement
struct ItemElement :Codable{
    let Item: Item
}

// MARK: - ItemItem
struct Item :Codable{
    let mediumImageUrls: [ImageURL]
    let itemName: String
    let itemUrl: String
}

// MARK: - ImageURL
struct ImageURL :Codable{
    let imageUrl: String
}

//
//  Item.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import Foundation

struct ResultItems: Codable {
    let Items: [ItemElement]
}

struct ItemElement: Codable {
    let Item: Item
}

struct Item: Codable {
    let mediumImageUrls: [ImageURL]
    let itemName: String
    let itemUrl: String
    let itemCaption: String
    let itemPriceMin3: Int
    let shopName: String
}

struct ImageURL: Codable {
    let imageUrl: String
}

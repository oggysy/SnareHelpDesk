//
//  Item.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import Foundation

struct ResultItems :Codable{
    let Items: [ItemElement]
}

struct ItemElement :Codable{
    let Item: Item
}

struct Item :Codable{
    let mediumImageUrls: [ImageURL]
    let itemName: String
    let itemCaption: String
    let itemUrl: String
}

struct ImageURL :Codable{
    let imageUrl: String
}

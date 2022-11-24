//
//  ProductResponse.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import Foundation

struct ProductResponse: Decodable {
    var item: Item
}

struct Item: Decodable {
    var props: Props
}

struct Props: Decodable {
    var pageProps: PageProps
}

struct PageProps: Decodable {
    var initialData: InitialData
}

struct InitialData: Decodable {
    var searchResult: SearchResult
}

struct SearchResult: Decodable {
    var itemStacks: [ItemStacks]
}

struct ItemStacks: Decodable {
    var items: [Items]
}

struct Items: Decodable {
    var name: String?
    var price: Int?
    var image: String?
}

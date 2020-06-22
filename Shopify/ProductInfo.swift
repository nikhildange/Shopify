//
//  ProductInfo.swift
//  Shopify
//
//  Created by nikhil on 22/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import Foundation

struct ProductInfo: Codable {
    let categories: [Category]
    let rankings: [Ranking]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    let products: [Product]
    let childCategories: [Int]

    enum CodingKeys: String, CodingKey {
        case id, name, products
        case childCategories = "child_categories"
    }
}

// MARK: - CategoryProduct
struct Product: Codable {
    let id: Int
    let name, dateAdded: String
    let variants: [Variant]
    let tax: Tax

    enum CodingKeys: String, CodingKey {
        case id, name
        case dateAdded = "date_added"
        case variants, tax
    }
}

// MARK: - Tax
struct Tax: Codable {
    let name: String
    let value: Double
}


// MARK: - Variant
struct Variant: Codable {
    let id: Int
    let color: String
    let size: Int?
    let price: Int
}

// MARK: - Ranking
struct Ranking: Codable {
    let ranking: String
    let products: [RankingProduct]
}

// MARK: - RankingProduct
struct RankingProduct: Codable {
    let id: Int
    let viewCount, orderCount, shares: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case viewCount = "view_count"
        case orderCount = "order_count"
        case shares
    }
}

//
//// MARK: - ProductsResponse
//struct ProductInfo: Codable {
//    let categories: [Category]
//    let rankings: [Ranking]
//}
//
//// MARK: - Category
//struct Category: Codable {
//    let id: Int
//    let name: String
//    let products: [Product]
//    let childCategories: [Int]
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, products
//        case childCategories = "child_categories"
//    }
//
//}
//
//// MARK: - CategoryProduct
//struct Product: Codable {
//    let id: Int
//    let name: String
//    let dateAdded: Date
//    let variants: [Variant]
//    let tax: Tax
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case dateAdded = "date_added"
//        case variants, tax
//    }
//}
//
//// MARK: - Tax
//struct Tax: Codable {
//    let name: String
//    let value: Double
//}
//
//// MARK: - Variant
//struct Variant: Codable {
//    let id: Int
//    let color: String
//    let size: Int?
//    let price: Int
//}
//
//// MARK: - Ranking
//struct Ranking: Codable {
//    let ranking: String
//    let products: [Product]
//
//    // MARK: - RankingProduct
//    struct Product: Codable {
//        let id: Int
//        let viewCount, orderCount, shares: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case viewCount = "view_count"
//            case orderCount = "order_count"
//            case shares
//        }
//    }
//}
//
//

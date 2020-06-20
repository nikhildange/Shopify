//
//  APIResponseModel.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import CoreData
import Foundation

// MARK: - ProductsResponse
struct ProductsResponseModel: Codable {
    let categories: [CategoryResponseModel]
    let rankings: [RankingResponseModel]
}

// MARK: - Category
struct CategoryResponseModel: Codable {
    let id: Int
    let name: String
    let products: [CategoryProductResponseModel]
    let childCategories: [Int]

    enum CodingKeys: String, CodingKey {
        case id, name, products
        case childCategories = "child_categories"
    }
    
    func map(from dto: CategoryResponseModel, with context: NSManagedObjectContext) -> Category {
        let entity = Category(context: context)
        entity.id = Int32(dto.id)
        entity.name = dto.name
        for productData in dto.products {
            let product = productData.map(from: productData, with: context)
            product.category = entity
        }
        print("storing category")
        return entity
    }
}

// MARK: - CategoryProduct
struct CategoryProductResponseModel: Codable {
    let id: Int
    let name, dateAdded: String
    let variants: [VariantResponseModel]
    let tax: TaxResponseModel

    enum CodingKeys: String, CodingKey {
        case id, name
        case dateAdded = "date_added"
        case variants, tax
    }
    
    func map(from dto: CategoryProductResponseModel, with context: NSManagedObjectContext) -> Product {
        let entity = Product(context: context)
        entity.id = Int32(dto.id)
        entity.name = dto.name
        entity.dateAdded = Date()//dto.dateAdded
        for variantData in dto.variants {
            let variant = variantData.map(from: variantData, with: context)
            variant.variantOfProduct = entity
        }
        entity.tax = dto.tax.map(from: tax, with: context)
//        let rankInfo = RankingProductResponseModel(id: 0, viewCount: 0, orderCount: 0, shares: 0).map(context: context)
//        rankInfo.rankOfProduct = entity
        entity.rankInfo = Ranking(context: context)
        print("storing product")
        return entity
    }
}

// MARK: - Tax
struct TaxResponseModel: Codable {
    let name: String
    let value: Double
    
    func map(from dto: TaxResponseModel, with context: NSManagedObjectContext) -> Tax {
        let entity = Tax(context: context)
        entity.value = dto.value
        entity.name = dto.name
        print("storing tax")
        return entity
    }
}

// MARK: - Variant
struct VariantResponseModel: Codable {
    let id: Int
    let color: String
    let size: Int?
    let price: Int
    
    func map(from dto: VariantResponseModel, with context: NSManagedObjectContext) -> Variant {
        let entity = Variant(context: context)
        entity.id = Int32(dto.id)
        entity.color = dto.color
        entity.price = Int32(dto.price)
        if let size = dto.size {
            entity.size = Int32(size)
        }
        print("storing variant")
        return entity
    }
}

// MARK: - Ranking
struct RankingResponseModel: Codable {
    let ranking: String
    let products: [RankingProductResponseModel]
}

// MARK: - RankingProduct
struct RankingProductResponseModel: Codable {
    let id: Int
    let viewCount, orderCount, shares: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case viewCount = "view_count"
        case orderCount = "order_count"
        case shares
    }
    
    func map(context: NSManagedObjectContext) -> Ranking {
        let entity = Ranking(context: context)
        entity.viewCount = self.viewCount != nil ? Int32(self.viewCount!) : 0
        entity.orderCount = self.orderCount != nil ? Int32(self.orderCount!) : 0
        entity.shares = self.shares != nil ? Int32(self.shares!) : 0
//        if let product = DatabaseManager.getProduct(Id: self.id) {
//            DatabaseManager.getProduct(Id: self.id)!.rankInfo = entity
//        }
        print("storing rank")
        return entity
    }
}


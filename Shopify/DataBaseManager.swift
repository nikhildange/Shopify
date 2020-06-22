//
//  DataBaseManager.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import CoreData
import Foundation

struct DatabaseManager {
    
    static let coreDataManager = CoreDataManager(modelName: "DBModel")
    
    static func getCategory(Id: Int) -> Category? {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = NSPredicate(format: "id = %d", Id)
        do {
            let category = try coreDataManager.mainManagedObjectContext.fetch(request)
            return category.first
        } catch {
            print("Unable to fetch managed objects for entity Category.")
        }
        return nil
    }
    
    
    static func getProduct(Id: Int) -> Product? {
        let request = NSFetchRequest<Product>(entityName: "Product")
        request.predicate = NSPredicate(format: "id = %d", Id)
        do {
            let category = try coreDataManager.mainManagedObjectContext.fetch(request)
            return category.first
        } catch {
            print("Unable to fetch managed objects for entity Product.")
        }
        return nil
    }
    
    static func storeJSONToDB(data: ProductsResponseModel) {
        for categoryData in data.categories {
            _ = categoryData.map(from: categoryData, with: coreDataManager.mainManagedObjectContext)
        }
        for rankType in data.rankings {
            for rankData in rankType.products {
                do {
                let product = DatabaseManager.getProduct(Id: rankData.id)!
                    if let viewCount = rankData.viewCount {
                        product.rankInfo!.viewCount = Int32(viewCount)
                    }
                    if let orderCount = rankData.orderCount {
                        product.rankInfo!.orderCount = Int32(orderCount)
                    }
                    if let shares = rankData.shares {
                        product.rankInfo!.shares = Int32(shares)
                    }
                }
            }
        }
        coreDataManager.saveChanges()
    }
    
    static func getAllCategory() -> [Category] {
        let request = NSFetchRequest<Category>(entityName: "Category")
        do {
            let categories = try DatabaseManager.coreDataManager.mainManagedObjectContext.fetch(request)
            return categories
        } catch {
            print("Unable to fetch managed objects for entity categories.")
        }
        return []
    }
    
    static func getAllProduct(ofCategory: Int? = nil, sortBy: RankType? = RankType.order) -> [Product] {
        
        var sortKeyString: String = "rankInfo.orderCount"
        if let sortBy = sortBy {
            switch sortBy {
            case .order:
                sortKeyString = "rankInfo.orderCount"
            case .share:
                sortKeyString = "rankInfo.shares"
            case .views:
                sortKeyString = "rankInfo.viewCount"
            }
        }
        
        let request = NSFetchRequest<Product>(entityName: "Product")
        if let categoryID = ofCategory {
            request.predicate = NSPredicate(format: "category.id = %d", categoryID)
        }
        request.sortDescriptors = [NSSortDescriptor(key: sortKeyString, ascending: false)]
        
        do {
            let products = try DatabaseManager.coreDataManager.mainManagedObjectContext.fetch(request)
            return products
        } catch {
            print("Unable to fetch managed objects for entity products.")
        }
        
        return []
    }
    
    
//    func getVariantsOfProduct(id: Int) -> [Variant] {
//
//    }
}

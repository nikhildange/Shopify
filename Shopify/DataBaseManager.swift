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
    
    static func storeJSONToDB(data: ProductsResponseModel, completion: @escaping (_ success: Bool) -> Void) {
        for categoryData in data.categories {
            _ = categoryData.map(from: categoryData, with: coreDataManager.mainManagedObjectContext)
        }
        storeRank(data: data)
        coreDataManager.saveChanges()
        completion(true)
    }
    
    static func storeRank(data: ProductsResponseModel) {

        func updateRankObject(_ newOrUpdated: RankingProductResponseModel) {
            let request = NSFetchRequest<Product>(entityName: "Product")
            request.predicate = NSPredicate(format: "id = %d", newOrUpdated.id)
            request.returnsObjectsAsFaults = false
            do {
                let result = try coreDataManager.mainManagedObjectContext.fetch(request)
                if let rankInfo = result.first?.rankInfo {
                    if let viewCount = newOrUpdated.viewCount {
                       rankInfo.viewCount = Int32(viewCount)
                   }
                   if let orderCount = newOrUpdated.orderCount {
                       rankInfo.orderCount = Int32(orderCount)
                   }
                   if let shares = newOrUpdated.shares {
                       rankInfo.shares = Int32(shares)
                   }
                }
                else {
                    print("CREATE NEW RANK TB")
                }
            } catch {
                print("Unable to fetch managed objects for entity Rank for Updation.")
            }
        }
        
        for rankType in data.rankings {
            for rankData in rankType.products {
                updateRankObject(rankData)
            }
        }
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
    
}

//
//  NetworkManager.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import Foundation

struct NetworkManager {
    
static func requestProductData() {
    guard let url = URL(string: "https://stark-spire-93433.herokuapp.com/json") else {
        print("NW: Invalid URL")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: responseHandler(data:response:error:))
    task.resume()
}

static func responseHandler(data: Data?, response: URLResponse?, error: Error?) {
    guard let data = data else {
        print("NW: Data nil; Error: \(error?.localizedDescription ?? "nil")")
        return
    }
    
    do {
        let productsData = try JSONDecoder().decode(ProductsResponseModel.self, from: data)
        print(productsData)
        DatabaseManager.storeJSONToDB(data: productsData)
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    
        
        let cat1 = DatabaseManager.getCategory(Id: 1)
        print(cat1!.name)
        let cat2 = DatabaseManager.getCategory(Id: 2)
        print(cat2!.name!)
        print(DatabaseManager.getProduct(Id:14)!.category!.name as Any)
        
        let prd = DatabaseManager.getAllProduct(ofCategory: nil, ofRankType: nil, sortBy: .order)
        for i in prd {
            print("\(String(describing: i.id)) Product: \(String(describing: i.name)) \t\t viewCount:\(i.rankInfo!.viewCount) \t\t shares:\(i.rankInfo!.shares) \t\t orderCount:\(i.rankInfo!.orderCount)")
        }
        
    } catch (let error) {
        print("NW: Parsing Error: \(error.localizedDescription)")
    }
}

    
}


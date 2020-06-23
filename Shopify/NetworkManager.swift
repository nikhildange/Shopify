//
//  NetworkManager.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    static let baseUrl = "https://stark-spire-93433.herokuapp.com/json"
    static let shared: NetworkManager = {
        return NetworkManager()
    }()
    
    func requestProductData(completion: @escaping (Bool) -> Void) {
        fetchProductList { (productInfo) in
            try? CategoryEntity.deleteAll()
            CategoryEntity.saveAllInventory(productInfo: productInfo)
            completion(true)
        }
    }

    func fetchProductList(completionHandler: @escaping (ProductInfo) -> Void) {
        guard let url = URL(string: NetworkManager.baseUrl) else {
               print("NW: Invalid URL")
               return
           }
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data,response,error in
           guard let data = data else {
               print("NW: Data nil; Error: \(error?.localizedDescription ?? "nil")")
               return
           }
            do {
                let productInfo = try JSONDecoder().decode(ProductInfo.self, from: data)
                completionHandler(productInfo)
            } catch (let error) {
                print("NW: Parsing Error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
}


//
//  NetworkManager.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    static func requestProductData(completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "https://stark-spire-93433.herokuapp.com/json") else {
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
                try? CategoryEntity.deleteAll()
                CategoryEntity.saveAllInventory(productInfo: productInfo)
                completion(true)
            } catch (let error) {
                print("NW: Parsing Error: \(error.localizedDescription)")
                completion(false)
            }
        })
        task.resume()
    }

    
}


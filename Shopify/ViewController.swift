//
//  ViewController.swift
//  Shopify
//
//  Created by nikhil on 19/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

enum RankType: Int {
    case order = 0
    case share, views
    
    var stringValue: String {
        switch(self) {
        case .order:
            return "Most Ordered"
        case .share:
            return "Most Shared"
        case .views:
            return "Most Viewed"
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("ID: \t\t\t viewCount: \t\t shares: \t\t orderCount: \t Product: ")
        let products = DatabaseManager.getAllProduct(ofCategory: nil, sortBy: .order)
        for i in products {
            print("\(String(describing: i.id)) \t\t\t \(i.rankInfo!.viewCount) \t\t\t\t\t \(i.rankInfo!.shares) \t\t\t\t\t \(i.rankInfo!.orderCount) \t\t \(i.name!) ")
        }
        print("Total Products: \(products.count)")
        
        print("\n\n\n")
        
        print("ID: \t\t\t viewCount: \t\t shares: \t\t orderCount: \t Product: ")
        let productsV = DatabaseManager.getAllProduct(ofCategory: nil, sortBy: .views)
        for i in productsV {
            print("\(String(describing: i.id)) \t\t\t \(i.rankInfo!.viewCount) \t\t\t\t\t \(i.rankInfo!.shares) \t\t\t\t\t \(i.rankInfo!.orderCount) \t\t \(i.name!) ")
        }
        print("Total Products: \(productsV.count)")
        
    }


}


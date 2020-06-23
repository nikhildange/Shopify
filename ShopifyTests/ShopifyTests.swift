//
//  ShopifyTests.swift
//  ShopifyTests
//
//  Created by nikhil on 23/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import XCTest
@testable import Shopify

class ShopifyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testProductViewModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let productList = try? ProductEntity.fetchAll() as? [ProductEntity]
        
        XCTAssertNotNil(productList, "productList should not be nil")
        XCTAssertEqual(productList!.count > 0, true, "At least have one product")
        
        let productEntity = productList!.first!
        productEntity.tax?.name = "VAT5"
        productEntity.tax?.tax = 5.0
        let productVM = ProductViewModel(productEntity: productEntity)
        
        XCTAssertEqual(productVM.name, productEntity.name, "Product name is not Matching")
        XCTAssertEqual(productVM.tax, "5.0% [VAT5]", "Tax string is not Matching")
    }

    func testFetchService() {
        let fetchExpectation = expectation(description: "To fetch products data")
        NetworkManager.shared.fetchProductList { (products) in
            XCTAssertNotNil(products, "Products value should not be NIL")
            XCTAssertTrue(products.categories.count > 0, "Categories data should not be Empty")
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10.0) { (error) in
            debugPrint(error?.localizedDescription ?? "fetchExpectation error")
        }
    }

}

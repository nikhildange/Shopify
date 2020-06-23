//
//  ProductViewController.swift
//  Shopify
//
//  Created by nikhil on 21/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

struct ProductViewModel {
    
    private let productInfo: ProductEntity
    
    public init(productEntity: ProductEntity) {
        self.productInfo = productEntity
    }
    
    public var name: String {
        return productInfo.name!
    }
    
    public var dateAdded: String {
        return (productInfo.dateAdded!.toString(dateFormat: "dd-MMM-yyyy"))
    }
    
    public var tax: String {
        return "\(productInfo.tax!.tax)% [\(productInfo.tax!.name!)]"
    }
}

class ProductViewController: UIViewController {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productAddedDateLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var variantSegmentedControl: UISegmentedControl!
    @IBOutlet weak var variantStackView: UISegmentedControl!

    var productInfo: ProductEntity!
    var productVarientEntityList: [ProductVarientEntity] = []
    var selectedVariantIndex: Int? = nil {
        didSet {
            if let index = selectedVariantIndex {
                variantStackView.isHidden = false
                variantSegmentedControl.selectedSegmentIndex = index
                let selectedVariant = productVarientEntityList[index]
                colorLabel.text = selectedVariant.color
                priceLabel.text = "$ \(selectedVariant.price)"
                sizeLabel.text = "\(selectedVariant.size)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productVM = ProductViewModel(productEntity: productInfo)
        productNameLabel.text = productVM.name
        productAddedDateLabel.text = productVM.dateAdded
        taxLabel.text = productVM.tax
        
        setupGoHomeButton()
        setupVariantView()
    }

    func setupGoHomeButton() {
        let homeButton = UIBarButtonItem(title: "Take me 🏠", style: .plain, target: self, action: #selector(didTapAtHomeButton))
        navigationItem.rightBarButtonItems = [homeButton]
    }
    
    func setupVariantView() {
        if let variantsFromProductInfo = productInfo.variants {
            var counter = 1
            variantSegmentedControl.removeAllSegments()
            for item in variantsFromProductInfo {
                productVarientEntityList.append(item)
                variantSegmentedControl.insertSegment(withTitle: "Variant \(counter)", at: counter, animated: false)
                counter+=1
            }
            selectedVariantIndex = 0
        }
        else {
            variantStackView.isHidden = true
        }
    }

    @IBAction func didSelectIndexOf(_ sender: UISegmentedControl) {
        selectedVariantIndex = sender.selectedSegmentIndex
    }

    @IBAction func didTapAtHomeButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

}


extension Date
{
    func toString(dateFormat format: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}

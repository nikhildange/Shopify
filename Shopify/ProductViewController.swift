//
//  ProductViewController.swift
//  Shopify
//
//  Created by nikhil on 21/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productAddedDateLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var variantSegmentedControl: UISegmentedControl!
    @IBOutlet weak var variantStackView: UISegmentedControl!
    
    var productInfo: Product!
    var variants: [Variant] = []
    var selectedVariantIndex: Int? = nil {
        didSet {
            if let index = selectedVariantIndex {
                variantStackView.isHidden = false
                variantSegmentedControl.selectedSegmentIndex = index
                let selectedVariant = variants[index]
                colorLabel.text = selectedVariant.color
                priceLabel.text = "$ \(selectedVariant.price)"
                sizeLabel.text = "\(selectedVariant.size)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productNameLabel.text = productInfo.name!
        productAddedDateLabel.text = productInfo.dateAdded?.toString(dateFormat: "dd-MMM-yyyy")
        categoryButton.setTitle(productInfo.category!.name!, for: .normal)
        taxLabel.text = "\(productInfo.tax!.value) [\(productInfo.tax!.name!)]"
        addGoHomeButton()
        
        if let variantsFromProductInfo = productInfo.variants {
            var counter = 1
            variantSegmentedControl.removeAllSegments()
            for item in variantsFromProductInfo {
                variants.append(item as! Variant)
                variantSegmentedControl.insertSegment(withTitle: "Variant \(counter)", at: counter, animated: false)
                counter+=1
            }
            selectedVariantIndex = 0
        }
        else {
            variantStackView.isHidden = true
        }
    }
    
    func addGoHomeButton() {
        let homeButton = UIBarButtonItem(title: "Take me 🏠", style: .plain, target: self, action: #selector(didTapAtHomeButton))
        navigationItem.rightBarButtonItems = [homeButton]
    }
    
    @IBAction func didSelectIndexOf(_ sender: UISegmentedControl) {
        selectedVariantIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func didTapAtHomeButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapAtCategoryButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewControllerID") as! CategoryCollectionViewController
        vc.categoryInfo = productInfo.category!
        navigationController?.pushViewController(vc, animated: true)
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
    func toDate(from stringDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: stringDate)!
    }
}

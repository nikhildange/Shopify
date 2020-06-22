//
//  ProductCollectionViewCell.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

struct ProductCollectionViewCellViewModel {
    
    // MARK: - Properties
    let product: Product
    
    var name: String {
        return product.name!
    }
    
}


class ProductCollectionViewCell: UICollectionViewCell, ReusableCell {

    // MARK: - Properties
    static let reuseIdentifier = "ProductCollectionViewCellID"
    static let nibName = "ProductCollectionViewCell"
    
    override func awakeFromNib() {
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.cornerRadius = 4
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.borderWidth = 1
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            // Configure Title Label
            titleLabel.numberOfLines = 3
        }
    }
    
    func configure(viewModel: ProductCollectionViewCellViewModel) {
        titleLabel.text = viewModel.name
    }

    
}

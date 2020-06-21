//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//


import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

struct CategoryCollectionViewCellViewModel {
    
    // MARK: - Properties
    let category: Category
    
    var name: String {
        return category.name!
    }
    
}


class CategoryCollectionViewCell: UICollectionViewCell, ReusableCell {

    // MARK: - Properties
    static let reuseIdentifier = "CategoryCollectionViewCellID"
    static let nibName = "CategoryCollectionViewCell"
    
    override func awakeFromNib() {
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.cornerRadius = 4
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.borderWidth = 2
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            // Configure Title Label
            titleLabel.numberOfLines = 2
        }
    }
    
    func configure(viewModel: CategoryCollectionViewCellViewModel) {
        titleLabel.text = viewModel.name
    }

    
}

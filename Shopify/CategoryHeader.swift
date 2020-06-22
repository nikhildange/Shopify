//
//  CategoryHeader.swift
//  Shopify
//
//  Created by nikhil on 22/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

protocol CategoryHeaderDelegate {
    func didTapCategoryBackButton()
    func didTapCategoryHomeButton()
}

class CategoryHeader: UICollectionReusableView {
    
    static let categoryHeader = "categoryHeader"
    static let categoryHeaderID = "categoryHeaderID"
    let stackView   = UIStackView()
    let label = UILabel()
    let backButton = UIButton()
    let homeButton = UIButton()
    
    var categoryHeaderDelegate: CategoryHeaderDelegate!
    var headerTitle: String? = nil {
        didSet {
            backButton.setTitle("< \(headerTitle ?? "Categories")", for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        label.text  = ""
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        
        homeButton.setTitle("[ 🏠 ]", for: .normal)
        homeButton.titleLabel?.font = homeButton.titleLabel?.font.withSize(20)
        homeButton.setTitleColor(.black, for: .normal)
        homeButton.translatesAutoresizingMaskIntoConstraints = true
        homeButton.addTarget(self, action: #selector(didTapAtHomeButton(sender:)), for: .touchUpInside)
        
        backButton.setTitle(" ＜ \(headerTitle ?? "")", for: .normal)
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(20)
        backButton.setTitleColor(.black, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapAtBackButton(sender:)), for: .touchUpInside)
        
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 8.0

        stackView.addArrangedSubview(homeButton)
        stackView.addArrangedSubview(backButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapAtBackButton(sender: Any) {
        categoryHeaderDelegate.didTapCategoryBackButton()
    }
    
    @objc func didTapAtHomeButton(sender: Any) {
        categoryHeaderDelegate.didTapCategoryHomeButton()
    }
}

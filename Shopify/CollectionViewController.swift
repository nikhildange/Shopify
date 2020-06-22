//
//  CollectionViewController.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var categoryDataSource = [Category]()
    var productDataSource = [Product]()
    var productRankViewType: RankType = .order
    
    private let cellId = "cellId"
    
    
    init() {
        super.init(collectionViewLayout: CollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = CollectionViewController.createLayout()
        collectionView.backgroundColor = .white
        navigationItem.title = "Shopify"
        
        let categoryXib = UINib(nibName: CategoryCollectionViewCell.nibName, bundle: nil)
        collectionView.register(categoryXib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        let productXib = UINib(nibName: ProductCollectionViewCell.nibName, bundle: nil)
        collectionView.register(productXib, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: CategoryHeader.categoryHeader, withReuseIdentifier: CategoryHeader.categoryHeaderID)
        collectionView.register(RankSegmentView.self, forSupplementaryViewOfKind: RankSegmentView.rankSegmentView, withReuseIdentifier: RankSegmentView.rankSegmentViewID)
        
        categoryDataSource = DatabaseManager.getAllCategory()
        productDataSource = DatabaseManager.getAllProduct()
        
        collectionView.reloadData()
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                let insetValue: CGFloat = 8
                let itemWidth: NSCollectionLayoutDimension = .fractionalWidth(0.9)
                let itemHeight: NSCollectionLayoutDimension = .absolute(90)
                    
                let item1 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item1.contentInsets.bottom = insetValue
                item1.contentInsets.trailing = insetValue
                
                let item2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item2.contentInsets.bottom = insetValue
                item2.contentInsets.trailing = insetValue
                
                let group1 = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.45), heightDimension: .estimated(500)), subitems: [item1, item2])
                let section = NSCollectionLayoutSection(group: group1)
                section.contentInsets = .init(top: 16, leading: 8, bottom: 32, trailing: 16)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(50)), elementKind: CategoryHeader.categoryHeader, alignment: .top)
                             ]
                return section
            } else {
                let insetValue: CGFloat = 8
                    let itemWidth: NSCollectionLayoutDimension = .fractionalWidth(0.32)
                let itemHeight: NSCollectionLayoutDimension = .absolute(180)
                    
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item.contentInsets.trailing = insetValue
                item.contentInsets.bottom = insetValue
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/2)), subitems: [item])
                    
                let item2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item2.contentInsets.trailing = insetValue
                item2.contentInsets.bottom = insetValue
                let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/2)), subitems: [item2])
                    
                let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .estimated(1000))
                let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerGroupSize, subitems: [group, group2])
                    
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.contentInsets = .init(top: 16, leading: 8, bottom: 8, trailing: 8)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(70)), elementKind: RankSegmentView.rankSegmentView, alignment: .top)
                             ]
                return section
                }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return categoryDataSource.count
        }
        else if section == 1 {
            return 6
        }
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = .red
            cell.configure(viewModel: CategoryCollectionViewCellViewModel(category: categoryDataSource[row]))
            return cell
        }
        else if section == 1 {
            if row < 5 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
                cell.backgroundColor = .gray
                cell.configure(viewModel: ProductCollectionViewCellViewModel(product: productDataSource[row]))
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                
                let seeMoreButton = UIButton()
                seeMoreButton.setTitle("See more..", for: .normal)
                seeMoreButton.setTitleColor(UIColor.gray, for: .normal)
                seeMoreButton.frame = cell.contentView.bounds
                seeMoreButton.contentMode = .bottomRight
                seeMoreButton.addTarget(self, action: #selector(seeMoreTapped(_:)), for: .touchUpInside)
                cell.contentView.addSubview(seeMoreButton)
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeader.categoryHeaderID, for: indexPath)
            return header
        }
        else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RankSegmentView.rankSegmentViewID, for: indexPath) as! RankSegmentView
            header.selectedRankType = productRankViewType
            header.delegate = self
            return header
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let section = indexPath.section
        if section == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewControllerID") as! CategoryCollectionViewController
            vc.categoryInfo = categoryDataSource[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
            vc.productInfo = productDataSource[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK : Action
    
    @objc func seeMoreTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewControllerID") as! CategoryCollectionViewController
        vc.categoryInfo = nil
        vc.sortProductByRankType = productRankViewType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension CollectionViewController: RankSegmentViewDelegate {
    func didSelect(rankType: RankType) {
        productDataSource = DatabaseManager.getAllProduct(sortBy: rankType)
        productRankViewType = rankType
        collectionView.reloadSections(IndexSet(integer: 1))
    }
}

class CategoryHeader: UICollectionReusableView {
    
    static let categoryHeader = "categoryHeader"
    static let categoryHeaderID = "categoryHeaderID"
    
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        label.text = "Categories:"
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CategoryCollectionViewController.swift
//  Shopify
//
//  Created by nikhil on 22/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {
    
    var categoryInfo: Category?
    var productDataSource = [Product]()
    var sortProductByRankType: RankType = .order
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = CategoryCollectionViewController.createLayout()
        
        let productXib = UINib(nibName: ProductCollectionViewCell.nibName, bundle: nil)
        collectionView.register(productXib, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        collectionView.register(RankSegmentView.self, forSupplementaryViewOfKind: RankSegmentView.rankSegmentView, withReuseIdentifier: RankSegmentView.rankSegmentViewID)
        
        title = categoryInfo == nil ? "All Product's" : "\(categoryInfo?.name ?? "") Product's"
        
        fetchDataFromDB()
    }
    
    init() {
        super.init(collectionViewLayout: CategoryCollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
                let insetValue: CGFloat = 8
                    let itemWidth: NSCollectionLayoutDimension = .fractionalWidth(0.33)
                let itemHeight: NSCollectionLayoutDimension = .absolute(100)
                    
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item.contentInsets.trailing = insetValue
                item.contentInsets.bottom = insetValue
                    
                let item2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item2.contentInsets.trailing = insetValue
                item2.contentInsets.bottom = insetValue
                
            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .estimated(100))
                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [item,item2])
                    
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.contentInsets = .init(top: 16, leading: 8, bottom: 8, trailing: 8)
//                section.orthogonalScrollingBehavior = .groupPaging
            
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(70)), elementKind: RankSegmentView.rankSegmentView, alignment: .top)
                             ]
                return section
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.configure(viewModel: ProductCollectionViewCellViewModel(product: productDataSource[indexPath.row]))
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RankSegmentView.rankSegmentViewID, for: indexPath) as! RankSegmentView
        header.label.text = nil
        header.selectedRankType = sortProductByRankType
        header.delegate = self
        return header
    }
    
    
    // MARK: UICollectionViewDelegate
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
        vc.productInfo = productDataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchDataFromDB() {
        let categoryID = categoryInfo?.id == nil ? nil : Int(categoryInfo!.id)
        productDataSource = DatabaseManager.getAllProduct(ofCategory: categoryID, sortBy: sortProductByRankType)
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
}

extension CategoryCollectionViewController: RankSegmentViewDelegate {
    func didSelect(rankType: RankType) {
        sortProductByRankType = rankType
        fetchDataFromDB()
    }
}

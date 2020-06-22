//
//  CollectionViewController.swift
//  Shopify
//
//  Created by nikhil on 20/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit
import CoreData


class CollectionViewController: UICollectionViewController {
    
    var categoryEntityList:[CategoryEntity] = []
    var productEntityList:[ProductEntity] = []
    var parentCatergoryStack:[CategoryEntity] = []
    var productRankViewType: RankType = .order

    private let reuseIdentifier = "Cell"
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
        
        if let categoryEntityList = fetchCategoryDataFromDatabase(), !categoryEntityList.isEmpty {
            self.categoryEntityList = categoryEntityList
            self.productEntityList = fetchProductDataFromDatabase() ?? []
            collectionView.reloadData()
        }
        else {
            NetworkManager.requestProductData() {  [weak self]  (success) in
                if success {
                     DispatchQueue.main.async {
                        self?.categoryEntityList = self?.fetchCategoryDataFromDatabase() ?? []
                        self?.productEntityList = self?.fetchProductDataFromDatabase() ?? []
                        self?.collectionView.reloadData()
                    }
                }
                else {
                    print("Save Error")
                }
            }
        }
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
                section.contentInsets = .init(top: 8, leading: 8, bottom: 32, trailing: 8)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(60)), elementKind: CategoryHeader.categoryHeader, alignment: .topLeading)
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
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(80)), elementKind: RankSegmentView.rankSegmentView, alignment: .topLeading)
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
            return categoryEntityList.count
        }
        else if section == 1 {
            return productEntityList.count > 5 ? 6 : 0
        }
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
            cell.configure(viewModel: CategoryCollectionViewCellViewModel(category: categoryEntityList[row]))
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//            let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 50))
//            cell.layoutIfNeeded()
//            title.text = categoryEntityList[indexPath.item].name
//            cell.contentView.addSubview(title)
//            cell.contentView.layer.borderWidth = 1
            return cell
        }
        else if section == 1 {
            if row < 5 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
                cell.configure(viewModel: ProductCollectionViewCellViewModel(product: productEntityList[row]))
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeader.categoryHeaderID, for: indexPath) as! CategoryHeader
            header.categoryHeaderDelegate = self
            header.headerTitle = parentCatergoryStack.last?.name ?? nil
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
        let section = indexPath.section
        if section == 0 {
            let selectedCategory = categoryEntityList[indexPath.row]
            if selectedCategory.childCategories.count > 0 { // Reload list with subcategories
                parentCatergoryStack.append(selectedCategory)
                let predicate = NSPredicate(format: "ANY self.id in %@", selectedCategory.childCategories)
                guard let categoryList = try? CategoryEntity.fetch(predicate: predicate, sortDescriptor: nil) as? [CategoryEntity], categoryList.count > 0 else {
                    fatalError("No subcategory found")
                }
                categoryEntityList = categoryList
                collectionView.reloadSections(IndexSet(integer: 0))
                }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewControllerID") as! CategoryCollectionViewController
                vc.categoryInfo = selectedCategory
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
            vc.productInfo = productEntityList[indexPath.row]
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
    
    
    func fetchCategoryDataFromDatabase() -> [CategoryEntity]? {
        let predicate = NSPredicate(format: "self.parentCategoryId == -1")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let fetchData = try? CategoryEntity.fetch(predicate: predicate, sortDescriptor: sortDescriptor) as? [CategoryEntity]
        return fetchData
    }
    
    func fetchProductDataFromDatabase() -> [ProductEntity]?  {
            var predicate: NSPredicate? = nil
            var sortDescriptor: NSSortDescriptor? = nil
            
            switch productRankViewType {
            case .views:
                predicate = NSPredicate(format: "viewCount > 0")
                sortDescriptor = NSSortDescriptor(key: "viewCount", ascending: false)
                
            case.order:
                predicate = NSPredicate(format: "orderCount > 0")
                sortDescriptor = NSSortDescriptor(key: "orderCount", ascending: false)
                
            case .share:
                predicate = NSPredicate(format: "shares > 0")
                sortDescriptor = NSSortDescriptor(key: "shares", ascending: false)
            case .all:
                sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        }
            if let fetchList = try? ProductEntity.fetch(predicate: predicate, sortDescriptor: sortDescriptor) as? [ProductEntity] {
                return fetchList
            }
        return nil
    }

}

extension CollectionViewController: RankSegmentViewDelegate {
    func didSelect(rankType: RankType) {
        productRankViewType = rankType
        reloadProductData()
    }
    
    func reloadProductData()  {
        productEntityList = fetchProductDataFromDatabase() ?? []
        collectionView.reloadSections(IndexSet(integer: 1))
    }
    
    func reloadCategoryData() {
        categoryEntityList = fetchCategoryDataFromDatabase() ?? []
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}


extension CollectionViewController: CategoryHeaderDelegate {
    func didTapCategoryHomeButton() {
        parentCatergoryStack.removeAll()
        reloadCategoryData()
    }
    
    func didTapCategoryBackButton() {
        _ = parentCatergoryStack.popLast()
        if let parentCategory = parentCatergoryStack.last {
            let predicate = NSPredicate(format: "ANY self.id in %@", parentCategory.childCategories)
            guard let categoryList = try? CategoryEntity.fetch(predicate: predicate, sortDescriptor: nil) as? [CategoryEntity], categoryList.count > 0 else {
                fatalError("No subcategory found")
            }
            categoryEntityList = categoryList
            collectionView.reloadSections(IndexSet(integer: 0))
        }
        else {
            reloadCategoryData()
        }
    }
}


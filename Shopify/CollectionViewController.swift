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
    
    init() {
        super.init(collectionViewLayout: CollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                let insetValue: CGFloat = 8
                let itemWidth: NSCollectionLayoutDimension = .fractionalWidth(1.0)
                let itemHeight: NSCollectionLayoutDimension = .absolute(90)
                    
                let item1 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item1.contentInsets.bottom = insetValue
                item1.contentInsets.trailing = insetValue
                
                let item2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
                item2.contentInsets.bottom = insetValue
                item2.contentInsets.trailing = insetValue
                
                let group1 = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(500)), subitems: [item1, item2])
                let section = NSCollectionLayoutSection(group: group1)
                section.contentInsets = .init(top: 32, leading: 8, bottom: 32, trailing: 16)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [
                                .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(50)), elementKind: categoryHeaderId, alignment: .top)
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
                                .init(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(70)), elementKind: rankTypeHeader, alignment: .top)
                             ]
                return section
                            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            return header
        }
        else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: rankTypeHeaderId, for: indexPath) as! RankTypeHeader
            header.delegate = self
            return header
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UIViewController()
        controller.view.backgroundColor = indexPath.section == 0 ? .yellow : .blue
        navigationController?.pushViewController(controller, animated: true)
    }
    
    let headerId = "headerId"
    static let categoryHeaderId = "categoryHeaderId"
    
    let rankTypeHeaderId = "rankTypeHeaderId"
    static let rankTypeHeader = "rankTypeHeader"
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return categoryDataSource.count
        }
        else if section == 1 {
            return productDataSource.count
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
            cell.backgroundColor = .gray
            cell.configure(viewModel: ProductCollectionViewCellViewModel(product: productDataSource[row]))
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
    }
    
    private let cellId = "cellId"
    
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
        collectionView.register(Header.self, forSupplementaryViewOfKind: CollectionViewController.categoryHeaderId, withReuseIdentifier: headerId)
        
        collectionView.register(RankTypeHeader.self, forSupplementaryViewOfKind: CollectionViewController.rankTypeHeader, withReuseIdentifier: rankTypeHeaderId)
        
        categoryDataSource = DatabaseManager.getAllCategory()
        productDataSource = DatabaseManager.getAllProduct()
        collectionView.reloadData()
    }
    
    
}

class Header: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        label.text = "Categories"
        
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

extension CollectionViewController: RankTypeHeaderDelegate {
    func didSelect(rankType: RankType) {
        productDataSource = DatabaseManager.getAllProduct(sortBy: rankType)
        collectionView.reloadSections(IndexSet(integer: 1))
    }
}

protocol RankTypeHeaderDelegate {
    func didSelect(rankType: RankType)
}

class RankTypeHeader: UICollectionReusableView {
    var stackView   = UIStackView()
    let segmentControl = UISegmentedControl()
    let label = UILabel()
    let selectedRank: RankType = .order
    
    var delegate: RankTypeHeaderDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        label.text  = "See Product's:"
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        
        segmentControl.insertSegment(withTitle: RankType.order.stringValue, at: 0, animated: true)
        segmentControl.insertSegment(withTitle: RankType.share.stringValue, at: 1, animated: true)
        segmentControl.insertSegment(withTitle: RankType.views.stringValue, at: 2, animated: true)
        segmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.apportionsSegmentWidthsByContent = true
        
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.fillProportionally
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing   = 8.0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segmentControl)
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
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
            delegate?.didSelect(rankType: .order)
          break
          case 1:
            delegate?.didSelect(rankType: .share)
          break
          case 2:
            delegate?.didSelect(rankType: .views)
          default:
          break
       }
    }
}





//{
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//
//        // Do any additional setup after loading the view.
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 8
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        // Configure the cell
//
//        return cell
//    }
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
//    */
//
//}

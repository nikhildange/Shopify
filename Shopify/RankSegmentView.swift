//
//  RankSegmentView.swift
//  Shopify
//
//  Created by nikhil on 22/06/20.
//  Copyright © 2020 nikhil. All rights reserved.
//

import UIKit

protocol RankSegmentViewDelegate {
    func didSelect(rankType: RankType)
}

class RankSegmentView: UICollectionReusableView {

    static let rankSegmentViewID = "RankSegmentViewID"
    static let rankSegmentView = "RankSegmentView"
    
    var stackView   = UIStackView()
    let segmentControl = UISegmentedControl()
    let label = UILabel()
    var selectedRankType: RankType! {
        didSet {
            segmentControl.selectedSegmentIndex = selectedRankType.rawValue
        }
    }
    var delegate: RankSegmentViewDelegate!
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        label.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        label.text  = "Product's:"
        label.font = label.font.withSize(20)
        label.textAlignment = .left
        
        segmentControl.insertSegment(withTitle: RankType.order.stringValue, at: 0, animated: true)
        segmentControl.insertSegment(withTitle: RankType.share.stringValue, at: 1, animated: true)
        segmentControl.insertSegment(withTitle: RankType.views.stringValue, at: 2, animated: true)
        segmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        segmentControl.apportionsSegmentWidthsByContent = true
        
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackView.distribution  = UIStackView.Distribution.equalCentering
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

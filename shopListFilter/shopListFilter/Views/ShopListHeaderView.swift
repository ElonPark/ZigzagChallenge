//
//  ShopListHeaderView.swift
//  shopListFilter
//
//  Created by elon on 25/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

import RxSwift

class ShopListHeaderView: UIView, NibLoadable {
    
    @IBOutlet weak var weekTitleLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var filterValueBaseView: UIView!
    @IBOutlet weak var filterValueBaseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterValueLabel: UILabel!
    @IBOutlet weak var filterValueLabelHeightConstraint: NSLayoutConstraint!
    
    var filterValue: String = "" {
        didSet {
            filterValueLabel.text = filterValue
            filterValueLabelHeightConstraint.constant = filterValue.isEmpty ? 0 : 20
            
            filterValueBaseView.isHidden = filterValue.isEmpty
            filterValueBaseViewHeightConstraint.constant = filterValue.isEmpty ? 0 : 25
        }
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weekTitleLabel.text = ""
        
        filterButton.layer.masksToBounds = true
        filterButton.layer.cornerRadius = 5
        filterButton.layer.borderColor = UIColor.lightGray.cgColor
        filterButton.layer.borderWidth = 0.8
    }
}

//
//  ShopFilterCell.swift
//  shopListFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

class ShopFilterCell: UICollectionViewCell, HasIdentifier {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    
    var filter: Filter? {
        didSet {
            switch filter {
            case .age(let age):
                filterNameLabel.text = age.title
                
            case .style(let style):
                filterNameLabel.text = style.rawValue
                
            case .none:
                break
            }

            setSelected(isSelected)
            contentView.layer.borderColor = color?.cgColor
        }
    }
    
    var color: UIColor? {
        switch filter {
        case .age:
            return AppColor.cyan
        case .style:
            return AppColor.darkPink
        case .none:
            return nil
        }
    }
   
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected)
        }
    }
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            filterNameLabel.textColor = .white
            contentView.backgroundColor = color
        } else {
            filterNameLabel.textColor = color
            contentView.backgroundColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterNameLabel.text = ""
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

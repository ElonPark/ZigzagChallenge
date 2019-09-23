//
//  ShopFilterCell.swift
//  shopListFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

class ShopFilterCell: UICollectionViewCell, ReactorKit.View {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterNameLabel.text = ""
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: ShopRankingCellReactor) {
        
    }
}

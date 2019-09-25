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

class ShopFilterCell: UICollectionViewCell, ReactorKit.View, HasIdentifier {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
        
    var filter: Filter?
    
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
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: ShopFilterCellReactor) {
        reactor.state.map { $0.filter }
            .observeOn(MainScheduler.instance)
            .bind { [weak self] filter in
                guard let self = self else { return }
                self.filter = filter
                self.filterNameLabel.textColor = self.color
                self.contentView.layer.borderColor = self.color?.cgColor

                switch filter {
                case .age(let age):
                    self.filterNameLabel.text = age.title
                    
                case .style(let style):
                    self.filterNameLabel.text = style.rawValue
                }
        }
        .disposed(by: disposeBag)
    }
}

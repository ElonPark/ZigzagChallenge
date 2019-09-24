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
    
    func bind(reactor: ShopFilterCellReactor) {
        reactor.state.map { $0.filter }
            .bind { [weak self] filter in
                guard let self = self else { return }
                switch filter {
                case let age as Age:
                    let color = UIColor(named: "Cyan")
                    self.filterNameLabel.text = age.title
                    self.filterNameLabel.textColor = UIColor(named: "Cyan")
                    self.contentView.layer.borderColor = color?.cgColor
                    
                case let style as Style:
                    let color = UIColor(named: "DarkPink")
                    self.filterNameLabel.text = style.rawValue
                    self.filterNameLabel.textColor = color
                    self.contentView.layer.borderColor = color?.cgColor
                    
                default:
                    break
                }
        }
        .disposed(by: disposeBag)
    }
}

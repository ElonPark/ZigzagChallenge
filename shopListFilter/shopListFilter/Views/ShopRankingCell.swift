//
//  ShopRankingCell.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

import Kingfisher
import ReactorKit
import RxSwift
import RxCocoa

final class ShopRankingCell: UITableViewCell, ReactorKit.View, HasIdentifier {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var styleBackgroundView: UIView!
    @IBOutlet weak var firstStyleView: UIView!
    @IBOutlet weak var firstStyleLabel: UILabel!
    @IBOutlet weak var secondStyleView: UIView!
    @IBOutlet weak var secondStyleLabel: UILabel!
    
    private var firstStyle: String = "" {
        didSet {
            firstStyleView.isHidden = firstStyle.isEmpty
            firstStyleLabel.text = firstStyle
        }
    }
    
    private var secondStyle: String = "" {
        didSet {
            secondStyleView.isHidden = secondStyle.isEmpty
            secondStyleLabel.text = secondStyle
        }
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
        setImageViewToRound()
        setAgeViewLayer()
        setStyleViewLayer()
    }
    
    private func initUI() {
        rankLabel.text = ""
        shopImageView.image = nil
        nameLabel.text = ""
        ageView.backgroundColor = .clear
        ageLabel.text = ""
        
        styleBackgroundView.backgroundColor = .clear
        firstStyleLabel.text = ""
        secondStyleLabel.text = ""
    }
    
    private func setImageViewToRound() {
        shopImageView.layer.masksToBounds = true
        shopImageView.layer.borderColor = UIColor.lightGray.cgColor
        shopImageView.layer.borderWidth = 0.3
        shopImageView.layer.cornerRadius = shopImageView.bounds.size.height / 2
    }
    
    private func setAgeViewLayer() {
        ageView.layer.masksToBounds = true
        ageView.layer.borderColor = UIColor.lightGray.cgColor
        ageView.layer.borderWidth = 0.8
        ageView.layer.cornerRadius = 5
    }
    
    private func setStyleViewLayer() {
        styleBackgroundView.layer.masksToBounds = true
        styleBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        styleBackgroundView.layer.borderWidth = 0.8
        styleBackgroundView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shopImageView.kf.cancelDownloadTask()
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: ShopRankingCellReactor) {
        reactor.state.map { $0.shopRank }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind { [weak self] shopRank in
                guard let self = self else { return }
                self.rankLabel.text = "\(shopRank.rank)"
                self.shopImageView.kf.setImage(with: shopRank.shopImageURL)
                self.nameLabel.text = shopRank.shop.name
                self.ageLabel.text = shopRank.ageRangeText
                self.setStyleView(by: shopRank.styles.sorted(by: { $0.index < $1.index }))
        }
        .disposed(by: self.disposeBag)
    }
    
    private func setStyleView(by styles: [Style]) {
        styleBackgroundView.isHidden = styles.count < 1
        firstStyle = ""
        secondStyle = ""
        
        if styles.count == 1 {
            self.firstStyle = styles[0].rawValue
        } else if styles.count == 2 {
            self.firstStyle = styles[0].rawValue
            self.secondStyle = styles[1].rawValue
        }
    }
}

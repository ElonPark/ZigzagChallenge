//
//  ShopFilterViewController.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class ShopFilterViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        Log.verbose(type(of: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: ShopFilterViewReactor) {
        
        Observable.just(Reactor.Action.loadFilter)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .map { Reactor.Action.close }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .map { Reactor.Action.reset }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        filterCollectionView.rx.itemSelected
            .map { Reactor.Action.selectFilter($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}

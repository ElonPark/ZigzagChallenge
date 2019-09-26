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
import RxCocoa
import RxDataSources

final class ShopFilterViewController: UIViewController, StoryboardView {
    
    // MARK: UI
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: Properties
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ShopFilterSection>
    private let dataSource = DataSource(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ShopFilterCell.identifier,
            for: indexPath
            ) as? ShopFilterCell
        
        cell?.filter = item.filter
        cell?.isSelected = item.isSelected
        
        return cell ?? UICollectionViewCell()
        
    }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ShopFilterHeaderReusableView.identifier,
            for: indexPath
        ) as? ShopFilterHeaderReusableView
        
        headerView?.titleLabel.text = dataSource[indexPath.section].header
        
        return headerView ?? UICollectionReusableView()
    })
    
    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        Log.verbose(type(of: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.contentInset = UIEdgeInsets(top: 3, left: 0,
                                                         bottom: 3, right: 0)
        
        setResetButtonUI()
        bindCloseButtonTap()
    }
    
    private func setResetButtonUI() {
        resetButton.backgroundColor = .white
        resetButton.layer.masksToBounds = true
        resetButton.layer.cornerRadius = 5
        resetButton.layer.borderColor = AppColor.cyan?.cgColor
        resetButton.layer.borderWidth = 1
    }
    
    private func bindCloseButtonTap() {
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: ShopFilterViewReactor) {
        
        // Input
        
        Observable.just(Reactor.Action.loadFilter)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        filterCollectionView.rx.itemSelected
            .map { Reactor.Action.selectFilter($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        resetButton.rx.tap
            .map { Reactor.Action.reset }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        completeButton.rx.tap
            .do(afterNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .map { Reactor.Action.complete }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // Output
     
        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .bind(to: filterCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension ShopFilterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let gap: CGFloat = 10
        let sideInset: CGFloat = 15 * 2
        let width = UIScreen.main.bounds.size.width

        let filter = dataSource[indexPath.section].items[indexPath.item].filter
        switch filter {
        case .age:
            let lineItemCount: CGFloat = 4
            let cellWidth = (width - sideInset - (gap * (lineItemCount - 1))) / lineItemCount

            return CGSize(width: cellWidth, height: 35)

        case .style:
            let lineItemCount: CGFloat = 3
            let cellWidth = (width - sideInset - (gap * (lineItemCount - 1))) / lineItemCount
            
            return CGSize(width: cellWidth, height: 35)
        }
    }
}

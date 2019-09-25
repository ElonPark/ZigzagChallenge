//
//  ShopListViewController.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

import NVActivityIndicatorView
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class ShopListViewController: UIViewController, StoryboardView {
   
    // MARK: UI
    
    @IBOutlet weak var shopListTableView: UITableView!
    
    // MARK: Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    typealias DataSource = RxTableViewSectionedReloadDataSource<ShopListSection>
    private let dataSource = DataSource(configureCell: { (dataSource, tableView, indexPath, shopRank) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopRankingCell.identifier,
                                                 for: indexPath) as? ShopRankingCell
        let reactor = ShopRankingCellReactor(shopRank: shopRank)
        cell?.reactor = reactor

        return cell ?? UITableViewCell()
    })
    
    let isFiltered: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let filterButtonTap: PublishRelay<Void> = PublishRelay()
    let selectedFilters: PublishRelay<(age: [Age], style: [Style])> = PublishRelay()
    
    deinit {
        Log.verbose(type(of: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButtonTap
            .observeOn(MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                guard let filterVC = UIStoryboard.shopFilterVC() else { return }
                filterVC.modalPresentationStyle = .overFullScreen
                filterVC.reactor = ShopFilterViewReactor()
                filterVC.reactor?.state.map { $0.selectedFilters }
                    .bind(to: self.selectedFilters)
                    .disposed(by: filterVC.disposeBag)
                
                self.present(filterVC, animated: true)
        }
        .disposed(by: disposeBag)
    }

    func bind(reactor: ShopListViewReactor) {
        
        // Input
        
        Observable.just(Reactor.Action.loadData)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        selectedFilters
            .map(Reactor.Action.selectFilter)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // Output
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind { [weak self] isLoading in
                guard let self = self else { return }
                self.setLoadingIndicator(isLoading)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .bind(to: shopListTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isFiltered }
            .distinctUntilChanged()
            .bind(to: isFiltered)
            .disposed(by: self.disposeBag)
    }
    
}


extension ShopListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ShopListHeaderView.fromNib()
        headerView.weekTitleLabel.text = dataSource[section].header
        headerView.filterValue = dataSource[section].filterValue
        headerView.filterButton.rx.tap
            .bind(to: filterButtonTap)
            .disposed(by: headerView.disposeBag)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isFiltered.value {
            return 75.0
        } else {
            return 50.0
        }
    }
}

extension ShopListViewController: NVActivityIndicatorViewable {
    
    private func startLoading() {
        guard !isAnimating else { return }
        startAnimating()
    }
    
    private func endLoading() {
        guard isAnimating else { return }
        stopAnimating()
    }
    
    private func setLoadingIndicator(_ isLoading: Bool) {
        if isLoading {
            startLoading()
        } else {
            endLoading()
        }
    }
}

//
//  ShopListViewReactor.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class ShopListViewReactor: Reactor {
    
    enum Action {
        case loadData
        case selectFilter((age: [Age], style: [Style]))
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setFilter(Bool)
        case setShopRanking(ShopListSection)
        case updateShopRanking(ShopListSection)
    }
    
    struct State {
        var isLoading: Bool = false
        var isFiltered: Bool = false
        var selectedFilters = (age: [Age](), style: [Style]())
        var shopListSection: ShopListSection?
        var sections = [ShopListSection]()
    }
    
    let networkService: NetworkService
    let initialState: State
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            let startLoading: Observable<Mutation> = .just(.setLoading(true))
            let endLoading: Observable<Mutation> = .just(.setLoading(false))
            
            let data = networkService.sample()
                .asObservable()
                .map { weekRank in
                    let headerTitle = "\(weekRank.week)차 랭킹"
                    let items = weekRank.list.sorted(by: { $0.score < $1.score })
                        .enumerated()
                        .map { value -> ShopRank in
                            let (index, shop) = value
                            var shopRank = ShopRank(shop: shop)
                            shopRank.rank = index + 1
                            return shopRank
                    }
                    
                    return ShopListSection(header: headerTitle, items: items)
            }
            .map(Mutation.setShopRanking)
            
            return .concat(startLoading, data, endLoading)
            
        case .selectFilter(let ages, let styles):
            guard let section = currentState.shopListSection else {
                return .just(.setFilter(false))
            }
            
            if ages.isEmpty && styles.isEmpty {
                return .concat(.just(.updateShopRanking(section)), .just(.setFilter(false)))
            }
            
            var newSection = section
            newSection.filterValue = filterValue(ages: ages, styles: styles)
            newSection.items = section.items.compactMap { rank -> ShopRank? in
                let point = rank.calculationPoint(ages: ages, styles: styles)
                guard point > 1 else { return nil }
                var newRank = rank
                newRank.point = point
                return newRank
            }
            .sorted { $0.rankValue < $1.rankValue }
            .enumerated()
            .map { value in
                let (index, item) = value
                var newItem = item
                newItem.rank = index + 1
                return newItem
            }
            
            return .concat(.just(.updateShopRanking(newSection)), .just(.setFilter(true)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .setFilter(let isFiltered):
            newState.isFiltered = isFiltered
            
        case .setShopRanking(let section):
            newState.shopListSection = section
            newState.sections = [section]
            
        case .updateShopRanking(let section):
            newState.sections = [section]
        }
        
        return newState
    }
    
    private func filterValue(ages: [Age], styles: [Style]) -> String {
        let filterAgesValue = ages.sorted { $0.rawValue < $1.rawValue }
            .map { $0.title }
            .joined(separator: ", ")
        
        let filterStylesValue = styles.sorted { $0.index < $1.index }
            .map { $0.rawValue }
            .joined(separator: ", ")
        
        var filterValue: String = ""
        if filterAgesValue.isEmpty {
            filterValue = filterStylesValue
        } else if filterStylesValue.isEmpty {
            filterValue = filterAgesValue
        } else {
            filterValue = "\(filterAgesValue) / \(filterStylesValue)"
        }
        Log.debug(filterValue)
        return filterValue
    }
}

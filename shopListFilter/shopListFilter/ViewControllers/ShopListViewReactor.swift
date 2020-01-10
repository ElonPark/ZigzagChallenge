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
        case selectFilter(SelectedFilter)
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
        var selectedFilter: SelectedFilter = SelectedFilter()
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
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            let data = networkService.sample()
                .asObservable()
                .map { weekRank in
                    let headerTitle = "\(weekRank.week)차 랭킹"
                    let items = weekRank.list.sorted { $0.score > $1.score }
                        .enumerated()
                        .map { (index, shop) -> ShopRankingCellReactor in
                            var shopRank = ShopRank(shop: shop)
                            shopRank.rank = index + 1
                            return ShopRankingCellReactor(shopRank: shopRank)
                    }
                    
                    return ShopListSection(header: headerTitle, items: items)
            }
            .map(Mutation.setShopRanking)
            
            return .concat(startLoading, data, endLoading)
            
        case .selectFilter(let filterItem):
            guard let section = currentState.shopListSection else {
                return .just(.setFilter(false))
            }
            
            if filterItem.ages.isEmpty && filterItem.styles.isEmpty {
                let mutations: [Observable<Mutation>] = [
                    .just(.updateShopRanking(section)),
                    .just(.setFilter(false))
                ]
                return .concat(mutations)
            }
            
            var newSection = section
            newSection.filterValue = filterValue(by: filterItem)
            let filteredItems = filteredShopRanks(origin: section.items,
                                                  filter: filterItem)
            newSection.items = sortedShopRanks(filteredItems)
                .enumerated()
                .map { (index, item) in
                    var newItem = item
                    newItem.rank = index + 1
                    return ShopRankingCellReactor(shopRank: newItem)
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
    
    private func filterValue(by filterItem: SelectedFilter) -> String {
        let filterAgesValue = Array(filterItem.ages)
            .sorted { $0.rawValue < $1.rawValue }
            .map { $0.title }
            .joined(separator: ", ")
        
        let filterStylesValue = Array(filterItem.styles)
            .sorted { $0.index < $1.index }
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
        
        return filterValue
    }

    private func filteredShopRanks(origin items: [ShopRankingCellReactor], filter: SelectedFilter) -> [ShopRank] {
        return items.compactMap { reactor -> ShopRank? in
            let rank = reactor.currentState.shopRank
            let (agePoint, stylePoint) = rank.calculationPoint(by: filter)
            var newRank = rank
            newRank.agePoint = agePoint
            newRank.stylePoint = stylePoint
            
            guard newRank.point > 0 else { return nil }
            if !filter.ages.isEmpty && agePoint < 1 {
                return nil
            }
            if !filter.styles.isEmpty && stylePoint < 1 {
                return nil
            }
            if !filter.ages.isEmpty && !filter.styles.isEmpty {
                if agePoint < 1 || stylePoint < 1 {
                    return nil
                }
            }

            return newRank
        }
    }
    
    private func sortedShopRanks(_ items: [ShopRank]) -> [ShopRank] {
        var matchingMutilpleStyleItems = [ShopRank]()
        var matchingStyleItems = [ShopRank]()
        
        for item in items {
            if item.stylePoint > 1 {
                matchingMutilpleStyleItems.append(item)
            } else {
                matchingStyleItems.append(item)
            }
        }
        
        matchingMutilpleStyleItems.sort {
            if $0.stylePoint == $0.stylePoint {
                return $0.shop.score > $1.shop.score
            } else {
                return $0.stylePoint > $0.stylePoint
            }
        }
        
        matchingStyleItems.sort { $0.shop.score > $1.shop.score }
        matchingMutilpleStyleItems.append(contentsOf: matchingStyleItems)
        
        return matchingMutilpleStyleItems
    }
}

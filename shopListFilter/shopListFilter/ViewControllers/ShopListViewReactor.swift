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
            newSection.items = section.items.compactMap { rank -> ShopRank? in
                let (agePoint, stylePoint) = rank.calculationPoint(by: filterItem)
                var newRank = rank
                newRank.agePoint = agePoint
                newRank.stylePoint = stylePoint
                
                guard newRank.point > 0 else { return nil }
                if !filterItem.ages.isEmpty && agePoint < 1 {
                    return nil
                }
                if !filterItem.styles.isEmpty && stylePoint < 1 {
                    return nil
                }
                if !filterItem.ages.isEmpty && !filterItem.styles.isEmpty {
                    if agePoint < 1 || stylePoint < 1 {
                        return nil
                    }
                }
                
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
            
            return .concat(.just(.updateShopRanking(newSection)),
                           .just(.setFilter(true)))
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
}

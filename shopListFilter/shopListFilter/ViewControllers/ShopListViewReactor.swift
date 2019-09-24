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
        case setTitle(String)
        case setShopRanking(ShopListSection)
    }
    
    struct State {
        var isLoading: Bool = false
        var title: String = ""
        var selectedFilters = (age: [Age](), style: [Style]())
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
                    let items = weekRank.list.map { ShopRank(shop: $0) }
                        .sorted { $0.rankValue < $1.rankValue }
                    return ShopListSection(header: weekRank.week, items: items)
            }
            .map(Mutation.setShopRanking)
            
            return .concat([startLoading, data, endLoading])
            
        case .selectFilter(let ages, let styles):
            guard let section = currentState.sections.first else { return .empty() }
            let filterAgesValue = ages.sorted { $0.rawValue < $1.rawValue }
                .map { $0.title }
                .joined(separator: ", ")
            
            let filterStylesValue = styles.sorted { $0.index < $1.index }
                .map { $0.rawValue }
                .joined(separator: ", ")
            
            var newSection = section
            newSection.filterValue = "\(filterAgesValue) / \(filterStylesValue)"
            newSection.items = section.items.map { rank -> ShopRank in
                var newRank = rank
                newRank.calculationPoint(ages: ages, styles: styles)
                return newRank
            }
            .filter { $0.point > 1 }
            .sorted { $0.rankValue < $1.rankValue }
            
            return .just(.setShopRanking(newSection))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setTitle(let title):
            newState.title = title
        case .setShopRanking(let section):
            newState.sections = [section]
        }
        
        return newState
    }
}

//
//  ShopRankingCellReactor.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class ShopRankingCellReactor: Reactor {
        
    enum Action {
        case select(Bool)
    }
    
    enum Mutation {
        case setSelected(Bool)
    }
    
    struct State: Equatable {
        let shopRank: ShopRank
        var isSelected: Bool = false
    }
    
    let initialState: State
    
    init(shopRank: ShopRank) {
        defer { _ = self.state } // state 스트림 생성
        initialState = State(shopRank: shopRank)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .select(let isSelected):
            return .just(.setSelected(isSelected))
         }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .setSelected(let isSelected):
            newState.isSelected = isSelected
         }
        
        return newState
    }
}

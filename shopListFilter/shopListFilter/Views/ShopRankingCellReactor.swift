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
        // actiom cases
    }
    
    enum Mutation {
        // mutation cases
    }
    
    struct State: Equatable {
        let shopRank: ShopRank
    }
    
    let initialState: State
    
    init(shopRank: ShopRank) {
        defer { _ = self.state } // state 스트림 생성
        initialState = State(shopRank: shopRank)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        // switch action {
        // }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        // switch mutation {
        // }
        return newState
    }
    
}

extension ShopRankingCellReactor: Equatable {
    static func == (lhs: ShopRankingCellReactor, rhs: ShopRankingCellReactor) -> Bool {
          return lhs.currentState.shopRank.shop.name == rhs.currentState.shopRank.shop.name
      }
      
}

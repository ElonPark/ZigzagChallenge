//
//  ShopFilterCellReactor.swift
//  shopListFilter
//
//  Created by elon on 24/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class ShopFilterCellReactor: Reactor {
    
    enum Action {
        case select(Bool)
    }
    
    enum Mutation {
        case setIsSelected(Bool)
    }
    
    struct State {
        var isSelected: Bool
        let filter: Filter
    }
    
    let initialState: State
    
    init(filter: Filter, isSelected: Bool) {
        defer { _ = self.state } // state 스트림 생성
        initialState = State(isSelected: isSelected, filter: filter)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
           switch action {
           case .select(let isSelected):
            return .just(.setIsSelected(isSelected))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsSelected(let isSelected):
            newState.isSelected = isSelected
        }
        
        return newState
    }
}

//
//  ShopFilterViewReactor.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class ShopFilterViewReactor: Reactor {
    
    enum Action {
        case close
        case reset
        case loadFilter
        case selectFilter(IndexPath)
    }
    
    enum Mutation {
        case close
        case reset
        case setLoadFilter(Bool)
        case setFilter(IndexPath)
    }
    
    struct State {
        //state
    }
    
    let initialState: State
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .close:
            break
         case .reset:
            return .just(.setLoadFilter(true))
            
         case .loadFilter:
            return .just(.setLoadFilter(false))
            
         case .selectFilter(let indexPath):
            Log.verbose(indexPath)
            break
         }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        // switch mutation {
        // }
        return newState
    }
    
}

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
    
    typealias Action = NoAction
    
    struct State {
        let filter: FilterType
    }
    
    let initialState: State
    
    init(filter: FilterType) {
        defer { _ = self.state } // state 스트림 생성
        initialState = State(filter: filter)
    }
}

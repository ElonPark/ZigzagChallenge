//
//  ShopListSection.swift
//  shopListFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import RxDataSources

enum ShopListSection: Equatable {
    case shopRanking([ShopListSectionItem])
}

extension ShopListSection {
    
    var items: [ShopListSectionItem] {
        switch self {
        case .shopRanking(let items):
            return items
        }
    }
    
    init(original: ShopListSection, items: [ShopListSectionItem]) {
        switch original {
        case .shopRanking:
            self = .shopRanking(items)
        }
    }
}

enum ShopListSectionItem: Equatable {
    case shop(ShopRankingCellReactor)
}

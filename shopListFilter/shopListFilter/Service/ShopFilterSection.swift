//
//  ShopFilterSection.swift
//  ShopFilterFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import RxDataSources

enum ShopFilterSection: Equatable {
    case ageFilter([ShopFilterSectionItem])
    case styleFilter([ShopFilterSectionItem])
}

extension ShopFilterSection {
    
    var items: [ShopFilterSectionItem] {
        switch self {
        case .ageFilter(let items):
            return items
        case .styleFilter(let items):
            return items
        }
    }
    
    init(original: ShopFilterSection, items: [ShopFilterSectionItem]) {
        switch original {
        case .ageFilter(let items):
            self = .ageFilter(items)
        case .styleFilter(let items):
            self = .styleFilter(items)
        }
    }
}

enum ShopFilterSectionItem: Equatable {
    case shop(ShopRankingCellReactor)
    case style(ShopRankingCellReactor)
}

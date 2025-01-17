//
//  ShopListSection.swift
//  shopListFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import RxDataSources

struct ShopListSection: Equatable {
    var header: String
    var filterValue: String = ""
    var items: [ShopRankingCellReactor]
}

extension ShopListSection: SectionModelType {
    
    init(original: ShopListSection, items: [ShopRankingCellReactor]) {
        self = original
        self.items = items
    }
}

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
    var items: [ShopRank]
}

extension ShopListSection {
    
    init(original: ShopListSection, items: [ShopRank]) {
        self = original
        self.items = items
    }
}

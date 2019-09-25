//
//  ShopFilterSection.swift
//  ShopFilterFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import RxDataSources

struct ShopFilterSection: Equatable {
    var header: String
    var items: [ShopFilterSectionItem]
}

extension ShopFilterSection: SectionModelType {
    
    init(original: ShopFilterSection, items: [ShopFilterSectionItem]) {
        self = original
        self.items = items
    }
}

struct ShopFilterSectionItem: Equatable {
    var isSelected: Bool
    var filter: Filter
}

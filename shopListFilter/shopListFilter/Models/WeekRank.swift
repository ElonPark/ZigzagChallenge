//
//  WeekRank.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import ObjectMapper

struct WeekRank: ImmutableMappable {
    
    let week: String
    let list: [Shop]
    
    init(map: Map) throws {
        week = try map.value("week")
        list = try map.value("list")
    }
}

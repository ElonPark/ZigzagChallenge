//
//  Shop.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import ObjectMapper

struct Shop: ImmutableMappable, Equatable {
    let score: Int
    let name: String
    let url: URL?
    let style: String
    let ageRange: [Int]
    
    init(map: Map) throws {
        score = try map.value("0")
        name = try map.value("n")
        let urlString: String = try map.value("u")
        url = URL(string: urlString)
        style = try map.value("S")
        ageRange = try map.value("A")
    }
}


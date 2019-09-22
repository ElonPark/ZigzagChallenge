//
//  ShopRank.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

struct ShopRank: Equatable {

    let shop: Shop
    
    var shopImageURL: URL? {
        guard let host = shop.url?.host else { return nil }
        let urlString = "https://cf.shop.s.zigzag.kr/images/\(host).jpg"
        return URL(string: urlString)
    }
    
    private(set) var ages: [Age] = []
    private(set) var styles: [Style] = []
    
    var ageRangeText: String {
        var rangeTitles: [String] = []
        for age in ages {
            if !rangeTitles.contains(age.rangeTitle) {
                rangeTitles.append(age.rangeTitle)
            }
        }
        
        return rangeTitles.joined(separator: " ")
    }
    
    var point: Int = 0
    var rank: Int = 0
    
    var rankValue: Int {
        return shop.score + point
    }
    
    init(shop: Shop) {
        self.shop = shop
        setAges(by: shop.ageRange)
        setStyles(by: shop.style)
    }
    
    private mutating func setAges(by ageRange: [Int]) {
        ages = []
        for (index, ageValue) in ageRange.enumerated() {
            guard ageValue == 1 else { continue }
            guard let age = Age(rawValue: index) else { continue }
            ages.append(age)
        }
    }
    
    private mutating func setStyles(by style: String) {
        styles = shop.style.components(separatedBy: ",")
            .compactMap { Style(rawValue: $0 ) }
    }
    
    mutating func calculationPoint(ages: [Age], styles: [Style]) {
        for age in ages {
            guard self.ages.contains(age) else { continue }
            point += 1
        }
        
        for style in styles {
            guard self.styles.contains(style) else { continue }
            point += 1
        }
    }
}

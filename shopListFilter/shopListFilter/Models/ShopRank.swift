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
    
    // FIXME: 메인 도메인만 가져올 수 있도록 수정 필요함.
    var shopImageURL: URL? {
        guard let host = shop.url?.host else { return nil }
        let removeWWW = host.replacingOccurrences(of: "www.", with: "")
        let removeCoKr = removeWWW.replacingOccurrences(of: ".co.kr", with: "")
        let removeKr = removeCoKr.replacingOccurrences(of: ".kr", with: "")
        let removeCom = removeKr.replacingOccurrences(of: ".com", with: "")
        let removeCafe = removeCom.replacingOccurrences(of: ".cafe24", with: "")
        
        let urlString = "https://cf.shop.s.zigzag.kr/images/\(removeCafe).jpg"
        return URL(string: urlString)
    }
    
    private(set) var ages: [Age] = []
    private(set) var styles: [Style] = []
    
    var ageRangeText: String {
        var rangeTitles: [String] = []
        var titleDic: [String: Age] = [:]
        for age in ages {
            if titleDic[age.rangeTitle] == nil {
                rangeTitles.append(age.rangeTitle)
                titleDic[age.rangeTitle] = age
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
    
    func calculationPoint(ages: [Age], styles: [Style]) -> Int {
        var point: Int = 0
        
        for age in ages {
            guard self.ages.contains(age) else { continue }
            point += 1
        }
        
        for style in styles {
            guard self.styles.contains(style) else { continue }
            point += 1
        }
        
        return point
    }
}

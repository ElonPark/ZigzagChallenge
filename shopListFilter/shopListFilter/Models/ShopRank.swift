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
    
    private(set) var ages: Set<Age> = Set()
    private(set) var styles: Set<Style> = Set()
    
    var ageRangeText: String {
        var titleDic: [String: Age] = [:]
        for age in ages {
            if titleDic[age.rangeTitle] == nil {
                titleDic[age.rangeTitle] = age
            }
        }
        
        return titleDic.values.sorted { $0.rawValue < $1.rawValue }
            .map { $0.rangeTitle }
            .joined(separator: " ")
    }
    
    var agePoint: Int = 0
    var stylePoint: Int = 0
    var point: Int {
        return agePoint + stylePoint
    }
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
        var ages: Set<Age> = Set()
        for (index, ageValue) in ageRange.enumerated() {
            guard ageValue == 1 else { continue }
            guard let age = Age(rawValue: index) else { continue }
            ages.insert(age)
        }
        
        self.ages = ages
    }
    
    private mutating func setStyles(by style: String) {
        let styleArray = shop.style.components(separatedBy: ",")
            .compactMap { Style(rawValue: $0 ) }
        styles = Set(styleArray)
    }
    
    func calculationPoint(by filterItem: SelectedFilter) -> (agePoint: Int, stylePoint: Int) {
        let agePoint = ages.intersection(filterItem.ages).count
        let stylePoint = styles.intersection(filterItem.styles).count
        return (agePoint, stylePoint)
    }
}

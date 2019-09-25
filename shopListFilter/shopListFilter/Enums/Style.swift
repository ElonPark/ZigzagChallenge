//
//  Style.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

enum Style: String, CaseIterable, Equatable, FilterType {
    case feminine = "페미닌"
    case modernChic = "모던시크"
    case simpleBasic = "심플베이직"
    case lovely = "러블리"
    case unique = "유니크"
    case missystyle = "미시스타일"
    case campusLook = "캠퍼스룩"
    case vintage = "빈티지"
    case sexyGlam = "섹시글램"
    case schoolLook = "스쿨룩"
    case romantic = "로맨틱"
    case officeLook = "오피스룩"
    case luxury = "럭셔리"
    case hollywoodStyle = "헐리웃스타일"
    
    var index: Int {
        switch self {
        case .feminine:
            return 0
        case .modernChic:
            return 1
        case .simpleBasic:
            return 2
        case .lovely:
            return 3
        case .unique:
            return 4
        case .missystyle:
            return 5
        case .campusLook:
            return 6
        case .vintage:
            return 7
        case .sexyGlam:
            return 8
        case .schoolLook:
            return 9
        case .romantic:
            return 10
        case .officeLook:
            return 11
        case .luxury:
            return 12
        case .hollywoodStyle:
            return 13
        }
    }
}

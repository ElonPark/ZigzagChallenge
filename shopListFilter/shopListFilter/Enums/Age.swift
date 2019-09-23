//
//  Age.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

enum Age: Int, FilterType {
    case teenager = 0
    case earlyTwenties
    case midTwenties
    case lateTwenties
    case earlyThirties
    case midThirties
    case lateThirties
    
    var title: String {
        switch self {
        case .teenager:
            return "10대"
        case .earlyTwenties:
            return "20대 초반"
        case .midTwenties:
            return "20대 중반"
        case .lateTwenties:
            return "20대 후반"
        case .earlyThirties:
            return "30대 초반"
        case .midThirties:
            return "30대 중반"
        case .lateThirties:
            return "30대 후반"
        }
    }
    
    var rangeTitle: String {
        switch self {
        case .teenager:
            return "10대"
        case .earlyTwenties, .midTwenties, .lateTwenties:
            return "20대"
        case .earlyThirties, .midThirties, .lateThirties:
            return "30대"
        }
    }
}

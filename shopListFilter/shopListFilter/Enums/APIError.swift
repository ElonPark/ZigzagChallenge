//
//  APIError.swift
//  shopListFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

enum APIError: Error {
    case missingDataAsset
    
    var localizedDescription: String {
        switch self {
        case .missingDataAsset:
            return "데이터 에셋을 찾을 수 없습니다."
        }
    }
}

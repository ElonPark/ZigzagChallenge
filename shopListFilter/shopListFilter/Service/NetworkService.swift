//
//  NetworkService.swift
//  shopListFilter
//
//  Created by elon on 23/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

import ObjectMapper
import RxSwift

protocol NetworkServiceType {
    func sample() -> Single<WeekRank>
}

struct NetworkService: NetworkServiceType {
    
    init() {
        
    }
    
    func sample() -> Single<WeekRank> {
        return Single.just("ShopList")
            .map { NSDataAsset(name: $0) }
            .map { dataAsset -> Data in
                guard let asset = dataAsset else { throw APIError.missingDataAsset }
                return asset.data
        }
        .map { try JSONSerialization.jsonObject(with: $0, options: .allowFragments) }
        .map { try WeekRank(JSONObject: $0) }
    }
}

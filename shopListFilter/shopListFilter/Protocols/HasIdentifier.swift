//
//  HasIdentifier.swift
//  shopListFilter
//
//  Created by elon on 25/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

protocol HasIdentifier {
    static var identifier: String { get }
}

extension HasIdentifier {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

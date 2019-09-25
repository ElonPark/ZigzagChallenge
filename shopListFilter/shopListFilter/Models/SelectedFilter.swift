//
//  SelectedFilter.swift
//  shopListFilter
//
//  Created by Elon on 25/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

struct SelectedFilter: Equatable {
    var ages: Set<Age> = Set()
    var styles: Set<Style> = Set()
}

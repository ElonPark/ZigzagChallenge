//
//  NibLoadable.swift
//  shopListFilter
//
//  Created by elon on 25/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    static var nibName: String { get }
    static func fromNib() -> Self
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static func fromNib() -> Self {
        return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! Self
    }
}

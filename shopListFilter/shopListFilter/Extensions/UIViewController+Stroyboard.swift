//
//  UIViewController+Stroyboard.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
}

extension UIViewController {
    static func instantiate<T: UIViewController>(by storyboardName: Storyboard) -> T? {
        let type = String(describing: T.Type.self)
        guard let identifier = type.components(separatedBy: ".").first else { return nil }
        
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return vc as? T
    }
}

extension UIStoryboard {
    static func shopFilterVC() -> ShopListViewController? {
        return UIViewController.instantiate(by: .main)
    }
}


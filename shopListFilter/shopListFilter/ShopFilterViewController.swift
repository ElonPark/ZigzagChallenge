//
//  ShopFilterViewController.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class ShopFilterViewController: UIViewController, StoryboardView {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: ShopFilterViewReactor) {
        //binding here
    }
    
}

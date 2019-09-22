//
//  ShopListViewController.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class ShopListViewController: UIViewController, StoryboardView {
   
    @IBOutlet weak var shopListTableView: UITableView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        Log.verbose(type(of: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    func bind(reactor: ShopFilterViewReactor) {
        
    }
    
}

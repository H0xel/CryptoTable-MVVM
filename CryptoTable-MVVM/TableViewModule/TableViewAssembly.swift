//
//  TableViewAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation
import EasyDi

class TableViewAssembly: Assembly {
    
    lazy private var routerAssembly: RouterAssembly = context.assembly()
    lazy private var cryptoCurrencyServiceAssembly: CryptoCurrencyServiceAssembly = context.assembly()
    
    var viewcontroller: TableViewController {
        define(init: TableViewController()) {
            $0.router = self.routerAssembly.router(viewController: $0)
            $0.tableModel = self.tableModel(viewcontroller: $0)
            $0.navigationItem.searchController = self.searchController
            return $0
        }
    }
}

extension TableViewAssembly {
    
    func tableModel(viewcontroller: UIViewController) -> TableViewModel {
        define(init: TableViewModelImpl()) {
            $0.service = self.cryptoCurrencyServiceAssembly.cryptoCurrencyService
            return $0
        }
    }
    
    var searchController: UISearchController {
        define(init: UISearchController()) {
            $0.obscuresBackgroundDuringPresentation = false
            $0.hidesNavigationBarDuringPresentation = true
            $0.searchBar.placeholder = "Search"
            return $0
        }
    }
}

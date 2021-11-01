//
//  TableViewAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation
import EasyDi
import Combine

class TableViewAssembly: Assembly {
    
    lazy private var routerAssembly: RouterAssembly = context.assembly()
    lazy private var cryptoCurrencyServiceAssembly: CryptoCurrencyServiceAssembly = context.assembly()
    lazy private var searchResultAssembly: SearchResultAssembly = context.assembly()
    
    var viewcontroller: TableViewController {
        define(init: TableViewController()) {
            $0.router = self.routerAssembly.router(viewController: $0)
            $0.tableModel = self.tableModel(viewcontroller: $0)
            let subject = self.searchSubject
            $0.searchTextSubject = subject
            $0.navigationItem.searchController = self.searchController($0, subject)
            return $0
        }
    }
}

extension TableViewAssembly {
    
    var searchSubject: CurrentValueSubject<String?, Never> {
        define(init: CurrentValueSubject<String?, Never>(nil))
    }
    
    func tableModel(viewcontroller: UIViewController) -> TableViewModel {
        define(init: TableViewModelImpl()) {
            $0.service = self.cryptoCurrencyServiceAssembly.cryptoCurrencyService
            return $0
        }
    }
    
    func searchController(_ updating: UISearchResultsUpdating, _ subject: CurrentValueSubject<String?, Never>) -> UISearchController {
        define(init: UISearchController(searchResultsController: self.searchResultAssembly.searchTableViewController(subject))) {
            $0.obscuresBackgroundDuringPresentation = false
            $0.hidesNavigationBarDuringPresentation = true
            $0.searchBar.placeholder = "Search"
            $0.searchResultsUpdater = updating
            return $0
        }
    }
}


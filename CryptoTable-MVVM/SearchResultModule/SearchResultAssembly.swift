//
//  SearchResultAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 25.10.2021.
//

import EasyDi
import Combine

class SearchResultAssembly: Assembly {
    
    lazy private var routerAssembly: RouterAssembly = context.assembly()
    lazy private var serviceAssembly: CryptoCurrencyServiceAssembly = context.assembly()
    lazy private var tableViewControllerAssembly: TableViewAssembly = context.assembly()
    
    func searchTableViewController(_ subject: CurrentValueSubject<String?, Never>) -> SearchResultTableView {
        define(init: SearchResultTableView()) {
            $0.router = self.routerAssembly.router(viewController: $0)
            $0.tableModel = self.tableModel(subject)
            return $0
        }
    }
}

extension SearchResultAssembly {
    func tableModel(_ subject: CurrentValueSubject<String?, Never>) -> TableViewModel {
        define(init: SearchResultViewModelImpl(search: subject)) {
            $0.service = self.serviceAssembly.cryptoCurrencyService
            
            return $0
        }
    }
}

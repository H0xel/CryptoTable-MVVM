//
//  CeryptoCurrencyServiceAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation
import EasyDi

class CryptoCurrencyServiceAssembly: Assembly {
    
    private lazy var networkService: NetworkServiceAssembly = context.assembly()
    
    var cryptoCurrencyService: CryptoCurrencyService {
        define(init: CryptoCurrencyServiceImpl()) {
            $0.network = self.networkService.networkService
            return $0
        }
    }
}

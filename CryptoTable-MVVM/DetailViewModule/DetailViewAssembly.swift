//
//  DetailViewAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation
import EasyDi

class DetailViewControllerAssembly: Assembly {
    
    func viewcontroller(currency: Cryptocurrency) -> UIViewController {
        define(init: DetailViewController()) {
            $0.detailModel = self.detailModel(cryptoCurrency: currency)
            return $0
        }
    }
}

extension DetailViewControllerAssembly {

    func detailModel(cryptoCurrency: Cryptocurrency) -> DetailViewModel {
        define(init: DeatilViewModelImpl()) {
            $0.cryptoCurrency = cryptoCurrency
            return $0
        }
    }
}

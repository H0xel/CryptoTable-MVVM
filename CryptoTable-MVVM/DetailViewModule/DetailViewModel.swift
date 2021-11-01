//
//  DeatailViewViewModel.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation
import Combine

protocol DetailViewModel {
    var state: CurrentValueSubject<CryptoDetailState, Error> { get }
    func fetch()
}

class DeatilViewModelImpl: DetailViewModel {
    
    var cryptoCurrency: Cryptocurrency!
    
    var state: CurrentValueSubject<CryptoDetailState, Error> = .init(CryptoDetailState(name: "", price: "", chart: nil))
    
    func fetch() {
        
        let url = URL(string: "https://3commas.io/ru\(cryptoCurrency.chartURL)")
        state.send(CryptoDetailState(name: cryptoCurrency.name,
                                     price: cryptoCurrency.formattedPrice,
                                     chart: url))
    }
}

//
//  SearchResultViewModel.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 25.10.2021.
//

import Foundation
import Combine


class SearchResultViewModelImpl: TableViewModel {
    
    
    var service: CryptoCurrencyService! // injected
    
    var state: CurrentValueSubject<TableViewModelState, Error> = .init(TableViewModelState(isOperating: false, cryptocurrency: [], error: nil))
    
    var currenciesState = [Cryptocurrency]()
    var tokens: Set<AnyCancellable> = []
    let searchText: CurrentValueSubject<String?, Never>
    
    init(search: CurrentValueSubject<String?, Never>) {
        searchText = search
        search
            .compactMap{$0}
            .removeDuplicates()
            .flatMap { self.service.search(substring: $0, loadedCount: 99) }
            .map { TableViewModelState(isOperating: false, cryptocurrency: $0.cryptocurrencies, error: nil)}
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    self.state.send(TableViewModelState(isOperating: false, cryptocurrency: [], error: error))
                }
            },
            receiveValue: {
                self.state.send($0)
            }).store(in: &tokens)
    }
    
    func fetch() {
        
    }
    
    func loadMore() {
        guard let text = searchText.value else { return }
        service.search(substring: text, loadedCount: 99)
            .map { TableViewModelState(isOperating: false, cryptocurrency: $0.cryptocurrencies, error: nil)}
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    self.state.send(TableViewModelState(isOperating: false, cryptocurrency: [], error: error))
                }
            },
            receiveValue: {
                self.state.value.cryptocurrency.append(contentsOf: $0.cryptocurrency)
            }).store(in: &tokens)
    }
    
    func cellState() -> [CryptoTableCellState] {
        map(state.value.cryptocurrency)
    }
    
    func map(_ cryptocurrencies: [Cryptocurrency]) -> [CryptoTableCellState] {
        cryptocurrencies.map { CryptoTableCellState(logo: URL(string: "https://3commas.io/ru\($0.logoURL)"),
                                                    name: $0.name,
                                                    symbol: $0.symbol)
        }
    }
}

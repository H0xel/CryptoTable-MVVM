//
//  TableViewVIewModel.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Combine
import Foundation

struct TableViewModelState: Equatable {
    
    let isOperating: Bool
    var cryptocurrency: [Cryptocurrency]
    let error: Error?
    
    static func ==(lhs: TableViewModelState, rhs: TableViewModelState) -> Bool {
        lhs.isOperating == rhs.isOperating && lhs.cryptocurrency == rhs.cryptocurrency
    }
}

protocol SearchModel {
    var searchText: CurrentValueSubject<String, Error> { get }
}

protocol TableViewModel: SearchModel {
    var searchText: CurrentValueSubject<String, Error> { get }
    var state: CurrentValueSubject<TableViewModelState, Error> { get }
    func fetch()
    func loadMore()
    func search()
    func cellState() -> [CryptoTableCellState]
}

class TableViewModelImpl: TableViewModel {
    
    var service: CryptoCurrencyService! // injected
    var router: Router! // injected
    
    var state: CurrentValueSubject<TableViewModelState, Error> = .init(TableViewModelState(isOperating: false, cryptocurrency: [], error: nil))
    var searchText: CurrentValueSubject<String, Error> = .init("")
    var serviceToken: AnyCancellable?
    var searchToken: AnyCancellable?
    var currenciesState = [Cryptocurrency]()
    
    func fetch() {
        state.send(TableViewModelState(isOperating: true, cryptocurrency: state.value.cryptocurrency, error: state.value.error)) // redux like
        
        serviceToken = service
            .get(loadedCount: 99)
            .map { TableViewModelState(isOperating: false, cryptocurrency: $0.cryptocurrencies, error: nil)}
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    self.state.send(TableViewModelState(isOperating: false, cryptocurrency: [], error: error))
                }
            },
            receiveValue: {
                self.state.send($0)
            })
    }
    
    func loadMore() {
        serviceToken = service.get(loadedCount: state.value.cryptocurrency.count)
            .map { TableViewModelState(isOperating: false, cryptocurrency: $0.cryptocurrencies, error: nil)}
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    self.state.send(TableViewModelState(isOperating: false, cryptocurrency: [], error: error))
                }
            },
            receiveValue: {
                self.state.value.cryptocurrency.append(contentsOf: $0.cryptocurrency)
            })
    }
    
    func search() {
        serviceToken = service.search(substring: searchText.value, loadedCount: state.value.cryptocurrency.count)
            .map { TableViewModelState(isOperating: false, cryptocurrency: $0.cryptocurrencies, error: nil)}
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    self.state.send(TableViewModelState(isOperating: false, cryptocurrency: [], error: error))
                }
            },
            receiveValue: {
                self.state.send($0)
            })
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


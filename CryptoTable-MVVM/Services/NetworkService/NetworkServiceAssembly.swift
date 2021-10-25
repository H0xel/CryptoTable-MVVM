//
//  NetworkAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation

import EasyDi

class NetworkServiceAssembly: Assembly { // IOC container
    
    var networkService: NetworkService {
        define(init: NetworkServiceImpl())
    }
}

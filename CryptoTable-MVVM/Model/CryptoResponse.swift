//
//  CryptoResponse.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import Foundation

// MARK: - CryptoResponse
struct CryptoResponse: Codable {
    let cryptocurrencies: [Cryptocurrency]
    let total: Int
}

// MARK: - Cryptocurrency
struct Cryptocurrency: Codable, Equatable {
    let logoURL, name, symbol, slug: String
    let price: Double
    let formattedPrice, change, marketCap, volume: String
    let circulatingSupply, issueDate: String
    let issuePrice: IssuePrice
    let chartURL: String
    let rank: Int

    enum CodingKeys: String, CodingKey {
        case logoURL = "logo_url"
        case name, symbol, slug, price
        case formattedPrice = "formatted_price"
        case change
        case marketCap = "market_cap"
        case volume
        case circulatingSupply = "circulating_supply"
        case issueDate = "issue_date"
        case issuePrice = "issue_price"
        case chartURL = "chart_url"
        case rank
    }
}

enum IssuePrice: String, Codable {
    case empty = "-"
}

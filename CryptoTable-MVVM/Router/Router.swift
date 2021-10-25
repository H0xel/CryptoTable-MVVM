//
//  Router.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import UIKit

protocol Router {
    func showCryptoDetail(currency: Cryptocurrency)
}

class RouterImpl: Router {
    weak var viewcontroller: UIViewController?
    var assembly: DetailViewControllerAssembly!
    
    func showCryptoDetail(currency: Cryptocurrency) {
        let vc = assembly.viewcontroller(currency: currency)
        viewcontroller?.present(vc, animated: true, completion: nil)
    }
}

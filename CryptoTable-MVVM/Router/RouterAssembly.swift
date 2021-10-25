//
//  RouterAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import EasyDi

class RouterAssembly: Assembly {
    
    private lazy var deatilAssembly: DetailViewControllerAssembly = context.assembly()
    
    func router(viewController: UIViewController) -> Router {
        define(scope: .prototype, init: RouterImpl()) {
            $0.viewcontroller = viewController
            $0.assembly = self.deatilAssembly
            return $0
        }
    }
}

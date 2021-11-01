//
//  DetailViewController.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import UIKit
import Kingfisher
import Combine

class DetailViewController: UIViewController {
    
    var detailModel: DetailViewModel! // injected
    var tokens: Set<AnyCancellable> = []
    
    lazy private var cryptoLoadView = CryptoDetailLoadView()
    
    override func loadView() {
        view = cryptoLoadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailModel
            .state
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveCompletion: {_ in}, receiveValue: { [weak self] in
                self?.cryptoLoadView.state = $0
            })
            .store(in: &tokens)
        
        detailModel.fetch()
        
    }
}

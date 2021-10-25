//
//  CryptoDetailLoadView.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 23.10.2021.
//

import UIKit
import Combine
import Kingfisher

struct CryptoDetailState: Equatable {
    let name: String
    let price: String
    let chart: URL?
}

class CryptoDetailLoadView: UIView {
    
    @Published var state: CryptoDetailState?
    var token: AnyCancellable?
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        
        return view
    }()
    
    let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black

        return label
    }()
    
    let currencyPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray

        return label
    }()
    
    let currencyChart: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        token = $state
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.currencyNameLabel.text = $0.name
                self?.currencyPriceLabel.text = $0.price
                self?.currencyChart.kf.setImage(with: $0.chart)
            }
        
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupConstraint() {

        addSubview(view)
        view.addSubview(currencyNameLabel)
        view.addSubview(currencyPriceLabel)
        view.addSubview(currencyChart)
        
        
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            view.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 3/4),
            view.heightAnchor.constraint(equalToConstant: 150),
        
            currencyNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            currencyNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
        
            currencyPriceLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor),
            currencyPriceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
        
            currencyChart.topAnchor.constraint(equalTo: currencyPriceLabel.bottomAnchor, constant: 10),
            currencyChart.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
        ])
    }
}

//
//  CryptoTableCellState.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import UIKit
import Combine
import Kingfisher

struct CryptoTableCellState: Equatable {
    let logo: URL?
    let name: String
    let symbol: String
}

class CryptoTableViewCell: UITableViewCell {
    
    @Published var state: CryptoTableCellState?
    var token: AnyCancellable?
    
    static let reuseId = "crypto_cell"
    
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    let logo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        token = $state.compactMap{$0}
            .removeDuplicates()
            .sink {
                self.nameLabel.text = $0.name
                self.symbolLabel.text = $0.symbol
                self.logo.kf.setImage(with: $0.logo)
            }
        setupConstraint()
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        
        selectedBackgroundView = selectedView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        addSubview(logo)
        addSubview(nameLabel)
        addSubview(symbolLabel)
        
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: centerYAnchor),
            logo.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            logo.widthAnchor.constraint(equalToConstant: 25),
            logo.heightAnchor.constraint(equalToConstant: 25),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: 20),
        
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            symbolLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 20)
        ])
    }
}

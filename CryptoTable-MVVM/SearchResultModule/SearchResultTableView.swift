//
//  SearchResultTableView.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 25.10.2021.
//

import UIKit
import Combine

class SearchResultTableView: UITableViewController {
    
    var router: Router!
    var tableModel: TableViewModel!
    var tokens: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.reuseId)
        
        tableModel
            .state
            .receive(on: DispatchQueue.main)
            .map(\.cryptocurrency)
            .removeDuplicates()
            .sink(receiveCompletion: {_ in}, receiveValue: {[weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &tokens)

        tableModel
            .state
            .receive(on: DispatchQueue.main)
            .map(\.error)
            .compactMap { $0 }
            .sink(receiveCompletion: {_ in}, receiveValue: {[weak self] in
                let alert = UIAlertController(title: nil, message: $0.localizedDescription, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            })
            .store(in: &tokens)

        
        tableModel.fetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.state.value.cryptocurrency.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.reuseId, for: indexPath) as! CryptoTableViewCell
        
        let state = tableModel.cellState()[indexPath.row]
        
        cell.state = state
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = tableModel.state.value.cryptocurrency[indexPath.row]
        router.showCryptoDetail(currency: currency)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

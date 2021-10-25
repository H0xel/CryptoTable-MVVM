//
//  ViewController.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 18.10.2021.
//

import UIKit
import Combine

class TableViewController: UITableViewController {
    
    
    var router: Router!
    var tableModel: (TableViewModel & SearchModel)!
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

        tableModel
            .state
            .receive(on: DispatchQueue.main)
            .map(\.isOperating)
            .removeDuplicates()
            .sink(receiveCompletion: {_ in}, receiveValue: {[weak self] in
                self?.toggle(isLoading: $0)
            })
            .store(in: &tokens)

        navigationItem
            .searchController?
            .searchBar
            .publisher(for: \.text)
            .sink(receiveValue: { [weak self] in
                self?.tableModel.searchText.send($0 ?? "")
            })
            .store(in: &tokens)

        tableModel.fetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tableModel.state.value.cryptocurrency.count)
        return tableModel.state.value.cryptocurrency.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tableModel.state.value.cryptocurrency.count - 1 {
            tableModel.loadMore()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.reuseId, for: indexPath) as! CryptoTableViewCell
        
        cell.state = tableModel.cellState()[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = tableModel.state.value.cryptocurrency[indexPath.row]
        router.showCryptoDetail(currency: currency)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension TableViewController {
    func toggle(isLoading: Bool) {}
}

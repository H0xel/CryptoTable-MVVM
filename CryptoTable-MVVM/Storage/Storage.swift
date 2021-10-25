//
//  Storage.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 20.10.2021.
//

import Foundation

enum StorageError: Error {
    case valueNotFound
}

protocol Storage {
    func set(data: Data, key: String)
    func get(key: String) throws -> Data
}

extension Storage {
    func set<T: Codable>(value: T, key: String) throws {
           let data = try JSONEncoder().encode(value)
           set(data: data, key: key)
    }
    
    func value<T: Codable>(key: String) throws -> T {
        let data = try get(key: key)
        let value = try JSONDecoder().decode(T.self, from: data)
        return value
    }
}

class UserDef: Storage {
    func set(data: Data, key: String) {
        UserDefaults.standard.setValue(data, forKey: key)
    }
    func get(key: String) throws -> Data {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            throw StorageError.valueNotFound
        }
        return data
    }
}


class FileManag: Storage {
    func set(data: Data, key: String) {
        FileManager.default.createFile(atPath: key, contents: data)
    }
    func get(key: String) throws -> Data {
        guard let data = FileManager.default.contents(atPath: key) else {
            throw StorageError.valueNotFound
        }
        return data
    }
}


class InMemoryStorage: Storage {
    static let shared = InMemoryStorage()
    var dictionary: [String: Data] = [:]
    
    func set(data: Data, key: String) {
        dictionary[key] = data
    }
    func get(key: String) throws -> Data {
        guard let data = dictionary[key] else {
            throw StorageError.valueNotFound
        }
        return data
    }
}

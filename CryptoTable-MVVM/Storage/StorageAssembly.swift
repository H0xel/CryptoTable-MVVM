//
//  StorageAssembly.swift
//  CryptoTable-MVVM
//
//  Created by Ivan Amakhin on 20.10.2021.
//

import Foundation
import EasyDi

class StoragesAssembly: Assembly {
    var inMemory: Storage {
        return define(scope: .lazySingleton, init: InMemoryStorage())
    }
    
    var userDefaults: Storage {
            return define(init: UserDef())
        }
    
    var filesystemStorage: Storage {
        return define(init: FileManag())
        }
}

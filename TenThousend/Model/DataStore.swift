//
//  DataStore.swift
//  TenThousend
//
//  Created by Linda on 2018-01-26.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

protocol DataStore {
    func setValue(_ value: Any?, forKey key: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: DataStore {}

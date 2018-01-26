//
//  PlayerManager.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

protocol PlayerManager {
    func addPlayer(name: String, avatar: Data)
    func updatePlayer(_: Player) throws
    func getAllPlayers() -> [Player]
    func removePlayer(_: Player) throws
}

enum PlayerError: Error {
    case nonExistingPlayer
}

class DicePlayerManager: PlayerManager {

    let dataStore: DataStore

    convenience init() {
        self.init(dataStore: UserDefaults.standard)
    }
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    func addPlayer(name: String, avatar: Data) {

    }

    func updatePlayer(_: Player) throws {
        throw PlayerError.nonExistingPlayer
    }

    func getAllPlayers() -> [Player] {
        return []
    }

    func removePlayer(_: Player) throws {
        throw PlayerError.nonExistingPlayer
    }
}

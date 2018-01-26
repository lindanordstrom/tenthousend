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
    func updatePlayer(_: Player, name: String, avatar: Data)
    func getAllPlayers() -> [Player]
    func removePlayer(_: Player)
}

class DicePlayerManager: PlayerManager {

    let dataStore: DataStore

    init(dataStore: DataStore = UserDefaults.standard) {
        self.dataStore = dataStore
    }

    func addPlayer(name: String, avatar: Data) {

    }

    func updatePlayer(_: Player, name: String, avatar: Data) {

    }

    func getAllPlayers() -> [Player] {
        return []
    }

    func removePlayer(_: Player) {

    }
}

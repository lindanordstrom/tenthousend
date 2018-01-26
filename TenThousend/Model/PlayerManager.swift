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
    case emptyPlayerList
}

class DicePlayerManager: PlayerManager {

    let dataStore: DataStore
    let playersKey = "Players"

    convenience init() {
        self.init(dataStore: UserDefaults.standard)
    }
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    func addPlayer(name: String, avatar: Data) {
        var currentPlayers = getAllPlayers()
        let newPlayer = Player(id: currentPlayers.count + 1, name: name, avatar: avatar)
        currentPlayers.append(newPlayer)
        updateCurrentPlayers(currentPlayers)
    }

    func updatePlayer(_ player: Player) throws {
        var currentPlayers = getAllPlayers()
        let index = try getPlayerIndex(currentPlayers, player: player)
        currentPlayers[index] = player
        updateCurrentPlayers(currentPlayers)
    }

    func getAllPlayers() -> [Player] {
        guard let players = dataStore.object(forKey: playersKey) as? [Player] else { return [] }
        return players
    }

    func removePlayer(_ player: Player) throws {
        var currentPlayers = getAllPlayers()
        let index = try getPlayerIndex(currentPlayers, player: player)
        currentPlayers.remove(at: index)
        updateCurrentPlayers(currentPlayers)
    }

    private func updateCurrentPlayers(_ players: [Player]) {
        dataStore.setValue(players, forKey: playersKey)
    }

    private func getPlayerIndex(_ players: [Player], player: Player) throws -> Int {
        guard !players.isEmpty else {
            throw PlayerError.emptyPlayerList

        }
        guard let i = players.index(where: { $0.id == player.id }) else {
            throw PlayerError.nonExistingPlayer
        }
        return i
    }
}

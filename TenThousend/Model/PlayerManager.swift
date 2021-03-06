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

    private enum DataStoreKeys: String {
        case players = "Players"
    }

    private let dataStore: DataStore
    private let uniqueIdentifier: UniqueIdentifier

    convenience init() {
        self.init(dataStore: UserDefaults.standard, uniqueIdentifier: UUID())
    }
    init(dataStore: DataStore, uniqueIdentifier: UniqueIdentifier) {
        self.dataStore = dataStore
        self.uniqueIdentifier = uniqueIdentifier
    }

    func addPlayer(name: String, avatar: Data) {
        var currentPlayers = getAllPlayers()
        let newPlayer = Player(id: uniqueIdentifier.uuidString, name: name, avatar: avatar)
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
        let players = dataStore.object(forKey: DataStoreKeys.players.rawValue) as? [Player]
        return players ?? []
    }

    func removePlayer(_ player: Player) throws {
        var currentPlayers = getAllPlayers()
        let index = try getPlayerIndex(currentPlayers, player: player)
        currentPlayers.remove(at: index)
        updateCurrentPlayers(currentPlayers)
    }

    private func updateCurrentPlayers(_ players: [Player]) {
        dataStore.setValue(players, forKey: DataStoreKeys.players.rawValue)
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

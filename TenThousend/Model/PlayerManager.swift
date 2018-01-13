//
//  PlayerManager.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

protocol PlaerManager {
    func addPlayer(name: String, avatar: Data)
    func updatePlayer(_: Player, name: String, avatar: Data)
    func getAllPlayers() -> [Player]
    func removePlayer(_: Player)
}

//
//  Player.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

class Player {
    let id: String
    var name: String
    var avatar: Data
    var currentGameData: CurrentGameData
    var bestTurn: Int?
    var quickestVictory: Int?

    init(id: String, name: String, avatar: Data) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.currentGameData = CurrentGameData()
    }
}

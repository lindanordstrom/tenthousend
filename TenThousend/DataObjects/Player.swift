//
//  Player.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

class Player {
    let id: Int
    var name: String
    var avatar: Data
    var currentGameData: CurrentGameData
    var bestTurn: Int?
    var quickestVictory: Int?

    init(id: Int, name: String, avatar: Data) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.currentGameData = CurrentGameData()
    }
}

extension Player: Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        return
            lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.avatar == rhs.avatar &&
                lhs.currentGameData == rhs.currentGameData
    }
}

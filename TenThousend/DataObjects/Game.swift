//
//  Game.swift
//  10000
//
//  Created by Linda on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

enum GameStatus {
    case ongoing
    case completed
    case cancelled
}

class Game {
    let id: Int
    let date: NSDate
    let target: Int
    let participants: [Player]
    var activePlayer: Player?
    var gameStatus: GameStatus
    var winnner: Player?

    init(id: Int, date: NSDate, target: Int, participants: [Player], gameStatus: GameStatus) {
        self.id = id
        self.date = date
        self.target = target
        self.participants = participants
        self.activePlayer = participants.first
        self.gameStatus = gameStatus
        self.winnner = nil
    }
}

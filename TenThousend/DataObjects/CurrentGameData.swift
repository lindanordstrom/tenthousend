//
//  CurrentGameData.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

struct CurrentGameData {
    var totalScore: Int = 0
    var turns: Int = 0
    var lastTurnScore: Int? 
}

extension CurrentGameData: Equatable {
    public static func == (lhs: CurrentGameData, rhs: CurrentGameData) -> Bool {
        return
            lhs.lastTurnScore == rhs.lastTurnScore &&
                lhs.totalScore == rhs.totalScore &&
                lhs.turns == rhs.turns
    }
}

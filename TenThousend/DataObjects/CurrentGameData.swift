//
//  CurrentGameData.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

class CurrentGameData: NSObject, NSCoding {
    var totalScore: Int = 0
    var turns: Int = 0
    var lastTurnScore: Int?

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(totalScore, forKey: "totalScore")
        aCoder.encode(turns, forKey: "turns")
        aCoder.encode(lastTurnScore, forKey: "lastTurnScore")
    }

    override init() {
        totalScore = 0
        turns = 0
    }

    init(totalScore: Int, turns: Int, lastTurnScore: Int?) {
        self.totalScore = totalScore
        self.turns = turns
        self.lastTurnScore = lastTurnScore
    }

    required public init?(coder aDecoder: NSCoder) {
        totalScore = aDecoder.decodeObject(forKey: "totalScore") as? Int ?? 0
        turns = aDecoder.decodeObject(forKey: "turns") as? Int ?? 0
        lastTurnScore = aDecoder.decodeObject(forKey: "lastTurnScore") as? Int
    }
}

//
//  Player.swift
//  10000
//
//  Created by Linda on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

class Player: NSObject, NSCoding {
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

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(currentGameData, forKey: "currentGameData")
        aCoder.encode(bestTurn, forKey: "bestTurn")
        aCoder.encode(quickestVictory, forKey: "quickestVictory")

    }

    required public init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        avatar = aDecoder.decodeObject(forKey: "avatar") as? Data ?? Data()
        currentGameData = aDecoder.decodeObject(forKey: "currentGameData") as? CurrentGameData ?? CurrentGameData()
        bestTurn = aDecoder.decodeObject(forKey: "bestTurn") as? Int
        quickestVictory = aDecoder.decodeObject(forKey: "quickestVictory") as? Int

    }
}

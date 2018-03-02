//
//  MainPageViewPresenter.swift
//  TenThousend
//
//  Created by Linda on 2018-02-03.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

protocol StartGameViewPresenter {
    func startGame()
    func addToGame(player: Player)
    func removeFromGame(player: Player)
    func createNewPlayer()
}

class StartGamePresenter: StartGameViewPresenter {

    private let ui: StartGameUI
    private var gameEngine: AnyObject?

    init(ui: StartGameUI) {
        self.ui = ui
    }

    func startGame() {
        // Check if there are more than 1 player in the game else...
        // Move UI along
    }

    func addToGame(player: Player) {
        // Check something?
        // Talk to GameEngine
    }

    func removeFromGame(player: Player) {
        // Check something else?
        // Talk to GameEngine
    }

    func createNewPlayer() {
        // Move UI along
    }
}

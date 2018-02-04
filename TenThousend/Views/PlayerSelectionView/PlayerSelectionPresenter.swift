//
//  PlayerSelectionPresenter.swift
//  TenThousend
//
//  Created by Yaser on 2018-02-04.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerSelectionViewPresenter {
    func dismissView()
    func numbersOfPlayers() -> Int
    func formatCell(at index: Int, playerCellClosure: (Player)->Void, createNewPlayerCellClosure: ()->Void)
    func select(item: Any?, at index: Int)
}

class PlayerSelectionPresenter: PlayerSelectionViewPresenter {

    private let ui: PlayerSelectionUI
    private let closure: ([Player]?)->Void
    private var players: [Player]?

    init(ui: PlayerSelectionUI, closure: @escaping ([Player]?)->Void ) {
        self.ui = ui
        self.closure = closure
        reloadPlayers()
    }

    func dismissView() {
        closure(nil)
    }

    func numbersOfPlayers() -> Int {
        reloadPlayers()
        guard let players = players else {
            return 0
        }
        return players.count + 1
    }

    func formatCell(at index: Int, playerCellClosure: (Player)->Void, createNewPlayerCellClosure: ()->Void) {
        reloadPlayers()
        guard let players = players else { return }

        if index < players.count {
            playerCellClosure(players[index])
        } else {
            createNewPlayerCellClosure()
        }
    }

    func select(item: Any?, at index: Int) {
        guard let players = players else { return }
        if index < players.count {
            ui.select(cell: item)
        } else {
            ui.showAddPlayerView()
        }
    }

    private func reloadPlayers() {
        players = DicePlayerManager().getAllPlayers()
    }
}



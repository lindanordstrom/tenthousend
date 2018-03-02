//
//  PlayerSelectionPresenter.swift
//  TenThousend
//
//  Created by Linda on 2018-02-04.
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
    private let dataStore: DataStore
    private let uniqueIdentifier: UniqueIdentifier

    init(ui: PlayerSelectionUI, dataStore: DataStore = UserDefaults.standard, uniqueIdentifier: UniqueIdentifier = UUID(), closure: @escaping ([Player]?)->Void) {
        self.ui = ui
        self.closure = closure
        self.dataStore = dataStore
        self.uniqueIdentifier = uniqueIdentifier
        reloadPlayers()
    }

    func dismissView() {
        closure(nil)
    }

    func numbersOfPlayers() -> Int {
        reloadPlayers()
        guard let players = players else {
            return 1
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
        reloadPlayers()
        guard let players = players else { return }
        if index < players.count {
            ui.select(cell: item)
        } else {
            ui.showAddPlayerView()
        }
    }

    private func reloadPlayers() {
        players = DicePlayerManager(dataStore: dataStore, uniqueIdentifier: uniqueIdentifier).getAllPlayers()
    }
}



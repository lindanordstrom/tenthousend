//
//  PlayerSelectionPresenter.swift
//  TenThousend
//
//  Created by Linda on 2018-02-04.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation
import UIKit

class PlayerSelectionPresenter {

    private let ui: PlayerSelectionUI
    private let closure: ([Player]?)->Void
    private var players: [Player]?
    private let dataStore: DataStore
    private let uniqueIdentifier: UniqueIdentifier
    private var selectedPlayers: [Player] = []

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

    func dismissViewWithSelectedPlayers() {
        // TODO add check if at least two players has been added
        closure(selectedPlayers)
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
            selectedPlayers.append(players[index])
            ui.select(cell: item)
        } else if players.count >= 10 {
            ui.showMaxUsersError()
        } else {
            ui.showAddPlayerView()
        }
    }

    func deselect(item: Any?, at index: Int) {
        reloadPlayers()
        guard let players = players else { return }
        if index < players.count {
            selectedPlayers = selectedPlayers.filter { $0.id != players[index].id }
            ui.deselect(cell: item)
        }
    }

    private func reloadPlayers() {
        players = DicePlayerManager(dataStore: dataStore, uniqueIdentifier: uniqueIdentifier).getAllPlayers()
    }
}



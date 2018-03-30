//
//  AddPlayerPresenter.swift
//  TenThousend
//
//  Created by Linda on 2018-02-03.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation
import UIKit

class AddPlayerPresenter {

    private let ui: AddPlayerUI
    private let playerManager: PlayerManager
    private let closure: (Player?)->Void

    init(ui: AddPlayerUI, playerManager: PlayerManager = DicePlayerManager(), closure: @escaping (Player?)->Void ) {
        self.ui = ui
        self.playerManager = playerManager
        self.closure = closure
    }

    func createNewPlayer(name: String?) {
        guard let name = name, !name.isEmpty else {
            ui.showErrorMissingDetailsError()
            return
        }
        let player = playerManager.addPlayer(name: name, avatar: Data())
        
        closure(player)
    }

    func dismissView() {
        closure(nil)
    }
}


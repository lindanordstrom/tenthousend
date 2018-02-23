//
//  AddPlayerPresenter.swift
//  TenThousend
//
//  Created by Yaser on 2018-02-03.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation
import UIKit

protocol AddPlayerViewPresenter {
    func createNewPlayer(name: String?)
    func dismissView()
}

class AddPlayerPresenter: AddPlayerViewPresenter {

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
            ui.showError(title: "Missing Name", message: "You need to enter a name", buttonTitle: "OK")
            return
        }
        let player = playerManager.addPlayer(name: name, avatar: Data())
        
        closure(player)
    }

    func dismissView() {
        closure(nil)
    }
}


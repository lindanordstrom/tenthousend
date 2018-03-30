//
//  AddPlayerView.swift
//  TenThousend
//
//  Created by Linda on 2018-02-03.
//  Copyright © 2018 YasLin. All rights reserved.
//

import UIKit

protocol AddPlayerUI {
    func showErrorMissingDetailsError()
}

class AddPlayerView: UIView, AddPlayerUI {

    @IBOutlet weak var nameInputField: UITextField?
    private var presenter: AddPlayerPresenter?

    func configure(closure: @escaping (Player?)->Void ) {
        self.presenter = AddPlayerPresenter(ui: self, closure: closure)
    }
    
    @IBAction func AddPlayerButton(_ sender: UIButton) {
        presenter?.createNewPlayer(name: nameInputField?.text)
    }

    @IBAction func CloseButton(_ sender: UIButton) {
        presenter?.dismissView()
    }

    func showErrorMissingDetailsError() {
        AlertHandler.showError(viewController: self.window?.rootViewController, title: "Missing Name", message: "You need to enter a name", buttonTitle: "OK")
    }
}

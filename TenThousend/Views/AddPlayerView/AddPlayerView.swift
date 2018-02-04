//
//  AddPlayerView.swift
//  TenThousend
//
//  Created by Yaser on 2018-02-03.
//  Copyright © 2018 YasLin. All rights reserved.
//

import UIKit

protocol AddPlayerUI {
    func showError(title: String, message: String, buttonTitle: String)
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

    func showError(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

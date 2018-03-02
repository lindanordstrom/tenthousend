//
//  MainPageViewController.swift
//  TenThousend
//
//  Created by Linda on 2018-01-27.
//  Copyright © 2018 YasLin. All rights reserved.
//

import UIKit

protocol StartGameUI {

}

class MainPageViewController: UIViewController, StartGameUI {

    private var presenter: StartGameViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = StartGamePresenter(ui: self)
    }

    @IBAction func StartGameButton(_ sender: UIButton) {
        guard let views = Bundle.main.loadNibNamed("PlayerSelectionView", owner: nil, options: nil) as? [UIView],
            let contentView = views.first as? PlayerSelectionView else {
            return
        }
        contentView.configure {_ in
            contentView.removeFromSuperview()
        }
        view.addSubview(contentView)
    }

    func showOngoing(game: Game) {
        //let next = OngoingGameViewController(game: game, somethingElse: AnyObject())
        //navigationController?.pushViewController(next, animated: true)
    }

    func showAddPlayer() {
        // Remove select player view
        // Show add player view
    }

    func newPlayerAdded() {
        // Remove add player view
        // Show select player view
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

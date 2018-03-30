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

    private var presenter: StartGamePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = StartGamePresenter(ui: self)
    }

    @IBAction func StartGameButton(_ sender: UIButton) {
        showPlayerSelection()
    }

    func showOngoing(game: Game) {
        //let next = OngoingGameViewController(game: game, somethingElse: AnyObject())
        //navigationController?.pushViewController(next, animated: true)
    }

    private func showPlayerSelection() {
        guard let views = Bundle.main.loadNibNamed("PlayerSelectionView", owner: nil, options: nil) as? [UIView],
            let playerSelectionView = views.first as? PlayerSelectionView else {
                return
        }
        playerSelectionView.configure { selectedPlayers in
            defer { playerSelectionView.removeFromSuperview() }
            guard let selectedPlayers = selectedPlayers else { return }
            for player in selectedPlayers {
                print(player.name)
            }
        }
        view.addSubview(playerSelectionView)
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

//
//  PlayerSelectionView.swift
//  TenThousend
//
//  Created by Linda on 2018-02-03.
//  Copyright © 2018 YasLin. All rights reserved.
//

import UIKit

protocol PlayerSelectionUI {
    func select(cell: Any?)
    func showAddPlayerView()
}

class PlayerSelectionView: UIView, PlayerSelectionUI {

    @IBOutlet weak var view: UIView?
    @IBOutlet private var playersCollectionView: UICollectionView?

    private let cellIdentifier = "playerCell"
    private var presenter: PlayerSelectionViewPresenter?

    override func awakeFromNib() {
        playersCollectionView?.register(UINib(nibName:"PlayerCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        playersCollectionView?.allowsMultipleSelection = true
    }

    func configure(closure: @escaping ([Player]?)->Void ) {
        self.presenter = PlayerSelectionPresenter(ui: self, closure: closure)
    }

    @IBAction func CloseButton(_ sender: UIButton) {
        presenter?.dismissView()
    }

    func select(cell: Any?) {
        guard let cell = cell as? PlayerCell else { return }
        print("You selected \(cell.name?.text ?? "")")
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0.9406109452, blue: 0, alpha: 1)
    }

    func deselect(cell: Any?) {
        guard let cell = cell as? PlayerCell else { return }
        print("You deselected \(cell.name?.text ?? "")")
        cell.layer.borderWidth = 0
    }

    func showAddPlayerView() {
        guard let views = Bundle.main.loadNibNamed("AddPlayerView", owner: nil, options: nil) as? [UIView],
            let contentView = views.first as? AddPlayerView else {
                return
        }
        contentView.configure {_ in
            self.playersCollectionView?.reloadData()
            self.playersCollectionView?.layoutIfNeeded()
            contentView.removeFromSuperview()
        }
        view?.addSubview(contentView)
    }
}

extension PlayerSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numbersOfPlayers() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PlayerCell else {
            return UICollectionViewCell()
        }

        presenter?.formatCell(at: indexPath.item, playerCellClosure: { player in
            cell.name?.text = player.name
        }, createNewPlayerCellClosure: {
            cell.name?.text = "Create new player"
        })

        return cell
    }
}

extension PlayerSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        presenter?.select(item: cell, at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        deselect(cell: cell)
    }
}

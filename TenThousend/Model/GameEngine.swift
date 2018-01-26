//
//  GameEngine.swift
//  10000
//
//  Created by Yaser on 2018-01-08.
//  Copyright © 2018 YasLin. All rights reserved.
//

import Foundation

protocol GameEngine {
    func startGame(players: [Player]) -> Bool
    func updateGame(score: Int)
    func cancelGame()
    func getAllGames() -> [Game]
    func add(observer: GameObserver)
    func remove(observer: GameObserver)
}

private struct GameEngineStrings {
    static let gamesKey = "Games"
}

class DiceGameEngine: GameEngine {
    private var currentGame: Game?
    private var gameObservers: [GameObserver] = []
    private let dataStore: DataStore

    convenience init() {
        self.init(dataStore: UserDefaults.standard)
    }

    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    func startGame(players: [Player]) -> Bool {
        guard !players.isEmpty,
            currentGame == nil
            else { return false }

        currentGame = Game(id: 1, date: NSDate(), target: 10000, participants: players, gameStatus: .ongoing)

        if let game = currentGame {
            var allGames = getAllGames()
            allGames.append(game)
            dataStore.setValue(allGames, forKey: GameEngineStrings.gamesKey)
        }

        updateGameObservers()
        return true
    }

    func updateGame(score: Int) {
        guard currentGame?.gameStatus == .ongoing else { return }

        currentGame?.activePlayer?.currentGameData.lastTurnScore = score
        currentGame?.activePlayer?.currentGameData.totalScore += score
        currentGame?.activePlayer?.currentGameData.turns += 1

        if playerDidWin() {
            finishGame()
        }

        changeActivePlayer()
        updateGameObservers()
    }

    func cancelGame() {
        guard currentGame?.gameStatus == .ongoing else { return }

        currentGame?.gameStatus = .cancelled
        currentGame?.activePlayer = nil
        updateGameObservers()
    }

    func getAllGames() -> [Game] {
        guard let games = dataStore.object(forKey: GameEngineStrings.gamesKey) as? [Game] else {
            return []
        }
        return games
    }

    func add(observer: GameObserver) {
        gameObservers.append(observer)
    }

    // TODO do not remove all
    func remove(observer: GameObserver) {
        gameObservers.removeAll()
    }

    private func playerDidWin() -> Bool {
        guard let game = currentGame,
            let totalScore = game.activePlayer?.currentGameData.totalScore else {
                return false
        }
        return totalScore >= game.target
    }

    private func changeActivePlayer() {
        guard let game = currentGame,
            let activePlayer = game.activePlayer,
            game.gameStatus == .ongoing else { return }

        let matchingIndex = game.participants.index(where: { $0.id == activePlayer.id })
        
        if let i = matchingIndex {
            let nextIndex = i + 1 >= game.participants.count ? 0 : i + 1
            currentGame?.activePlayer = currentGame?.participants[nextIndex]
        }
    }

    private func finishGame() {
        currentGame?.winnner = currentGame?.activePlayer
        currentGame?.activePlayer = nil
        currentGame?.gameStatus = .completed
    }

    private func updateGameObservers() {
        guard let game = currentGame else { return }

        for gameObserver in gameObservers {
            gameObserver.update(game: game)
        }
    }
}

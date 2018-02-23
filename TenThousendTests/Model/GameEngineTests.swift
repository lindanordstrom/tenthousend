//
//  GameEngineTests.swift
//  TenThousandTests
//
//  Created by Yaser on 2018-01-09.
//  Copyright © 2018 YasLin. All rights reserved.
//

import XCTest

@testable import TenThousend

class GameEngineTests: XCTestCase {

    private var testObject: GameEngine!
    private var testObserver: TestObserver!
    private var dataStore: TestUserDefaults!
    private var testPlayers = [Player(id: "a", name: "Linda", avatar: Data(capacity: 1)), Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))]
    private var expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
    private var expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))

    override func setUp() {
        super.setUp()

        dataStore = TestUserDefaults()
        testObject = DiceGameEngine(dataStore: dataStore)
        testObserver = TestObserver()
        testObject?.add(observer: testObserver)
    }

    override func tearDown() {
        testObject.remove(observer: testObserver)
        testObject = nil
        testObserver = nil
        dataStore = nil

        super.tearDown()
    }

    /**
     *  Given:  No users
     *  When:   Starting a game
     *  Then:   No game should be started
     *  And:    The function should return false
     */
    func testStartGameNoUsers() {
        let startedGameResult = testObject?.startGame(players: [])
        XCTAssert(startedGameResult == false)
        XCTAssert(testObserver?.updatedGame == nil)
    }

    /**
     *  Given:  Valid users
     *  When:   Starting a game
     *  Then:   A game should be started
     *  And:    The function should return true
     *  And:    The Game object should be updated with correct data
     *  And:    The new game is saved in the data storage
     */
    func testStartGame() {
        let startedGameResult = testObject.startGame(players: testPlayers)
        let expectedGame = Game(id: 01, date: NSDate(), target: 10000, participants: [expectedPlayer1, expectedPlayer2], gameStatus: .ongoing)
        expectedPlayer1.currentGameData = CurrentGameData(totalScore: 0, turns: 0, lastTurnScore: nil)
        expectedGame.activePlayer = expectedPlayer1
        expectedGame.winnner = nil

        XCTAssert(startedGameResult == true)
        XCTAssertNotNil(testObserver.updatedGame)
        assertGamesAreEqual(testGame: testObserver.updatedGame, expectedGame: expectedGame)
        XCTAssertEqual(dataStore.key, "Games")
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        assertGamesAreEqual(testGame: (dataStore.value as? [Game])?.first, expectedGame: expectedGame)
    }

    /**
     *  Given:  A game already started
     *  When:   Starting a new game
     *  Then:   No game should be started
     *  And:    The function should return false
     */
    func testStartGameWhileGameInProgress() {
        _ = testObject.startGame(players: testPlayers)
        testObserver.updateCalled = false

        let startedGameResult = testObject.startGame(players: testPlayers)

        XCTAssertFalse(testObserver.updateCalled)
        XCTAssertFalse(startedGameResult)
    }

    /**
     *  Given:  A game is ongoing
     *  When:   Updating the game with a non-winning score
     *  Then:   The game should be updated accordingly
     */
    func testUpdateGameWithNonWinningScore() {
        _ = testObject.startGame(players: testPlayers)

        testObject.updateGame(score: 200)
        testObject.updateGame(score: 5000)
        testObject.updateGame(score: 200)
        testObject.updateGame(score: 4000)
        testObject.updateGame(score: 300)

        let expectedGame = Game(id: 01, date: NSDate(), target: 10000, participants: [expectedPlayer1, expectedPlayer2], gameStatus: .ongoing)
        expectedPlayer1.currentGameData = CurrentGameData(totalScore: 700, turns: 3, lastTurnScore: 300)
        expectedPlayer2.currentGameData = CurrentGameData(totalScore: 9000,turns: 2,  lastTurnScore: 4000)
        expectedGame.activePlayer = expectedPlayer2
        expectedGame.winnner = nil

        assertGamesAreEqual(testGame: testObserver.updatedGame, expectedGame: expectedGame)
    }

    /**
     *  Given:  A game is ongoing
     *  When:   Updating the game with a winning score that makes total score more than the target
     *  Then:   The game should be updated accordingly
     */
    func testUpdateGameWithWinningScoreMoreThanTarget() {
        _ = testObject.startGame(players: testPlayers)

        testObject.updateGame(score: 10100)

        let expectedGame = Game(id: 01, date: NSDate(), target: 10000, participants: [expectedPlayer1, expectedPlayer2], gameStatus: .completed)
        expectedPlayer1.currentGameData = CurrentGameData(totalScore: 10100, turns: 1, lastTurnScore: 10100)
        expectedPlayer2.currentGameData = CurrentGameData(totalScore: 0, turns: 0, lastTurnScore: nil)
        expectedGame.activePlayer = nil
        expectedGame.winnner = expectedPlayer1

        assertGamesAreEqual(testGame: testObserver.updatedGame, expectedGame: expectedGame)
    }

    /**
     *  Given:  A game is ongoing
     *  When:   Updating the game with a winning score that makes total score exactly the target
     *  Then:   The game should be updated accordingly
     */
    func testUpdateGameWithWinningScoreExactAmount() {
        _ = testObject.startGame(players: testPlayers)

        testObject.updateGame(score: 10000)

        let expectedGame = Game(id: 01, date: NSDate(), target: 10000, participants: [expectedPlayer1, expectedPlayer2], gameStatus: .completed)
        expectedPlayer1.currentGameData = CurrentGameData(totalScore: 10000, turns: 1, lastTurnScore: 10000)
        expectedPlayer2.currentGameData = CurrentGameData(totalScore: 0, turns: 0, lastTurnScore: nil)
        expectedGame.activePlayer = nil
        expectedGame.winnner = expectedPlayer1

        assertGamesAreEqual(testGame: testObserver.updatedGame, expectedGame: expectedGame)
    }

    /**
     *  Given:  No game started
     *  When:   Updating the game
     *  Then:   Nothing should happen (no crash, no update)
     */
    func testUpdateGameWhenNoGameIsOngoing() {
        testObject.updateGame(score: 200)

        XCTAssert(testObserver?.updatedGame == nil)
    }

    /**
     *  Given:  The last game has finished with a winner
     *  When:   Updating the game
     *  Then:   Nothing should happen (no crash, no update)
     */
    func testUpdateGameWhenGameIsFinished() {
        _ = testObject.startGame(players: testPlayers)
        testObject.updateGame(score: 10000)
        testObserver.updateCalled = false

        testObject.updateGame(score: 200)

        XCTAssertFalse(testObserver.updateCalled)
        XCTAssert(testObserver?.updatedGame?.activePlayer == nil)
        XCTAssert(testObserver.updatedGame?.participants[0].currentGameData.lastTurnScore == 10000)
        XCTAssert(testObserver.updatedGame?.participants[1].currentGameData.lastTurnScore == nil)
    }

    /**
     *  Given:  The last game has been cancelled
     *  When:   Updating the game
     *  Then:   Nothing should happen (no crash, no update)
     */
    func testUpdateGameWhenGameIsCancelled() {
        _ = testObject.startGame(players: testPlayers)
        testObject.cancelGame()

        testObject.updateGame(score: 200)

        XCTAssert(testObserver?.updatedGame?.gameStatus == .cancelled)
        XCTAssert(testObserver?.updatedGame?.activePlayer == nil)
        XCTAssert(testObserver.updatedGame?.participants[0].currentGameData.lastTurnScore == nil)
        XCTAssert(testObserver.updatedGame?.participants[1].currentGameData.lastTurnScore == nil)
    }

    /**
     *  Given:  A game is ongoing
     *  When:   Cancelling the game
     *  Then:   The game should be cancelled
     */
    func testCancelOngoingGame() {
        _ = testObject.startGame(players: testPlayers)
        testObject.cancelGame()
        XCTAssertEqual(testObserver.updatedGame?.gameStatus, .cancelled)
    }

    /**
     *  Given:  No game started
     *  When:   Cancelling a game
     *  Then:   Nothing should happen (no crash, no update)
     */
    func testCancelGameWhenNoGameIsOngoing() {
        testObject.cancelGame()
        XCTAssertFalse(testObserver.updateCalled)
        XCTAssertNil(testObserver?.updatedGame)
    }

    /**
     *  Given:  The current game is cancelled
     *  When:   Cancelling a game
     *  Then:   Nothing should happen (no crash, no update)
     */
    func testCancelGameWhenAlreadyCancelled() {
        _ = testObject.startGame(players: testPlayers)
        testObject.cancelGame()
        testObserver?.updateCalled = false

        testObject.cancelGame()

        XCTAssertFalse(testObserver.updateCalled)
        XCTAssertEqual(testObserver.updatedGame?.gameStatus, .cancelled)
    }

    /**
     *  Given:  The current game is won
     *  When:   Cancelling a game
     *  Then:   Nothing should happen (no crash, no update)
     */
    func testCancelGameWhenGameIsFinished() {
        _ = testObject.startGame(players: testPlayers)
        testObject.updateGame(score: 10000)
        testObserver.updateCalled = false

        testObject.cancelGame()

        XCTAssertFalse(testObserver.updateCalled)
        XCTAssert(testObserver?.updatedGame?.gameStatus == .completed)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: Getting all players
     *  Then: A list of all players is returned
     */
    func testGetAllGames() {
        let expectedGame1 = Game(id: 01, date: NSDate(), target: 10000, participants: testPlayers, gameStatus: .completed)
        let expectedGame2 = Game(id: 02, date: NSDate(), target: 20000, participants: testPlayers, gameStatus: .cancelled)
        let expectedGame3 = Game(id: 03, date: NSDate(), target: 10000, participants: testPlayers, gameStatus: .ongoing)

        let expectedGameList = [expectedGame1, expectedGame2, expectedGame3]
        dataStore.value = expectedGameList

        let result = testObject.getAllGames()

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertEqual(dataStore.key, "Games")
        assertGamesAreEqual(testGame: result[0], expectedGame: expectedGame1)
        assertGamesAreEqual(testGame: result[1], expectedGame: expectedGame2)
        assertGamesAreEqual(testGame: result[2], expectedGame: expectedGame3)

    }

    /**
     *  Given: No games exists in storage
     *  When: Getting all games
     *  Then: An empty list is returned
     */
    func testGetAllGamesWhenNoGamesExists() {
        let result = testObject.getAllGames()

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertEqual(dataStore.key, "Games")
        XCTAssertTrue(result.isEmpty)
    }

    /**
     *  When:   Adding a broadcaster
     *  Then:   It should be passed to the broadcaster class
     */
    func testAddBroadcaster() {
        testObject.add(observer: testObserver)
        _ = testObject.startGame(players: testPlayers)
        XCTAssertTrue(testObserver.updateCalled)
    }

    /**
     *  When:   Removing a broadcaster
     *  Then:   It should be removed from the broadcaster class
     */
    func testRemoveBroadcaster() {
        testObject.remove(observer: testObserver)
        _ = testObject.startGame(players: testPlayers)
        XCTAssertFalse(testObserver.updateCalled)
    }
    
}

extension GameEngineTests {
    func assertGamesAreEqual(testGame: Game?, expectedGame: Game) {
        XCTAssertNotNil(testGame)
        guard let testGame = testGame else {
            return
        }
 
        XCTAssertEqual(testGame.gameStatus, expectedGame.gameStatus)

        let testPlayers = testGame.participants.map({return $0.id})
        let expectedPlayers = expectedGame.participants.map({return $0.id})
        XCTAssertEqual(testPlayers, expectedPlayers)

        XCTAssertEqual(testGame.target, expectedGame.target)
        XCTAssertEqual(testGame.winnner?.id, expectedGame.winnner?.id)
        XCTAssertEqual(testGame.activePlayer?.id, expectedGame.activePlayer?.id)
    }
}

private class TestObserver: GameObserver {
    var updatedGame: Game?
    var updateCalled = false
    func update(game: Game) {
        updateCalled = true
        updatedGame = game
    }
}

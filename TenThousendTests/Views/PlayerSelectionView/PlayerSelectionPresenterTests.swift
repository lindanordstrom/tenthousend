//
//  PlayerSelectionPresenterTests.swift
//  TenThousendTests
//
//  Created by Yaser on 2018-02-23.
//  Copyright © 2018 YasLin. All rights reserved.
//

import XCTest

@testable import TenThousend

class PlayerSelectionPresenterTests: XCTestCase {

    private var testObject: PlayerSelectionViewPresenter!
    private var testPlayerSelectionUI: TestPlayerSelectionUI!
    private var dataStore: TestUserDefaults!
    private var uniqueIdentifier: PlayerManagerTestUUID!
    private var playerSelectionPresenterClosureWasCalled: Bool!
    private var selectedPlayers: [Player]?
    private let player1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
    private let player2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        
    override func setUp() {
        super.setUp()
        testPlayerSelectionUI = TestPlayerSelectionUI()
        playerSelectionPresenterClosureWasCalled = false
        selectedPlayers = nil
        dataStore = TestUserDefaults()
        uniqueIdentifier = PlayerManagerTestUUID()
        testObject = PlayerSelectionPresenter(ui: testPlayerSelectionUI, dataStore: dataStore, uniqueIdentifier: uniqueIdentifier) { players in
            self.playerSelectionPresenterClosureWasCalled = true
            self.selectedPlayers = players
        }
    }

    override func tearDown() {
        testPlayerSelectionUI = nil
        dataStore = nil
        uniqueIdentifier = nil
        testObject = nil

        super.tearDown()
    }

    /**
     *  Given:
     *  When:   View is dismissed
     *  Then:   The player selection presenter closure should be called
     *  And:    No players should be returned in the closure
     */
    func testDismissView() {
        testObject.dismissView()
        XCTAssertTrue(playerSelectionPresenterClosureWasCalled)
        XCTAssertNil(selectedPlayers)
    }

    /**
     *  Given:  Players exists
     *  When:   Asked how many player slots to display
     *  Then:   The number returned should be number of players + 1
     */
    func testNumberOfPlayersWhenPlayersExists() {
        let playerList = [player1, player2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: playerList as NSArray) as NSData

        let result = testObject.numbersOfPlayers()

        XCTAssertEqual(result, 3)
    }

    /**
     *  Given:  No players previously exists
     *  When:   Asked how many player slots to display
     *  Then:   The number returned should be 1
     */
    func testNumberOfPlayersWhenNoPlayersExists() {
        let result = testObject.numbersOfPlayers()
        XCTAssertEqual(result, 1)
    }

    /**
     *  Given:  Players exists
     *  When:   Asked how to format the cell for any cell except the last cell
     *  Then:   The player cell closure should be called with correct player data
     */
    func testFormatCellNotTheLastCell() {
        let playerList = [player1, player2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: playerList as NSArray) as NSData
        let exp = expectation(description: "player cell closure")

        testObject.formatCell(at: 1, playerCellClosure: { player in
            XCTAssertEqual(player2.id, player.id)
            exp.fulfill()
        }) {}

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    /**
     *  Given:  Players exists
     *  When:   Asked how to format the last cell
     *  Then:   The create new player cell closure should be called
     */
    func testFormatCellWhenItIsTheLastCell() {
        let playerList = [player1, player2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: playerList as NSArray) as NSData
        let exp = expectation(description: "create new player cell closure")

        testObject.formatCell(at: 2, playerCellClosure: {_ in }) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    /**
     *  Given:  Players exists
     *  When:   Asked what should happen when selecting any cell except the last cell
     *  Then:   The select cell function in the UI should be called
     */
    func testSelectCellNotLastCell() {
        let playerList = [player1, player2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: playerList as NSArray) as NSData

        testObject.select(item: "testCell", at: 1)

        XCTAssertTrue(testPlayerSelectionUI.selectCellWasCalled)
        XCTAssertEqual(testPlayerSelectionUI.cell as? String, "testCell")
    }

    /**
     *  Given:  Players exists
     *  When:   Asked what should happen when selecting the last cell
     *  Then:   The create new player function in the UI should be called
     */
    func testSelectCellWhenItIsTheLastCell() {
        let playerList = [player1, player2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: playerList as NSArray) as NSData

        testObject.select(item: "testCell", at: 2)

        XCTAssertTrue(testPlayerSelectionUI.showAddPlayerViewWasCalled)
        XCTAssertNil(testPlayerSelectionUI.cell)
    }
    
}

private class TestPlayerSelectionUI: PlayerSelectionUI {

    var selectCellWasCalled = false
    var showAddPlayerViewWasCalled = false
    var cell: Any?

    func select(cell: Any?) {
        selectCellWasCalled = true
        self.cell = cell
    }
    func showAddPlayerView() {
        showAddPlayerViewWasCalled = true
    }
}

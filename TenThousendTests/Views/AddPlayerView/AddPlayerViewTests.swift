//
//  AddPlayerViewTests.swift
//  TenThousendTests
//
//  Created by Yaser on 2018-02-23.
//  Copyright © 2018 YasLin. All rights reserved.
//

import XCTest

@testable import TenThousend

class AddPlayerViewTests: XCTestCase {
        
    private var testObject: AddPlayerViewPresenter!
    private var testAddPlayerUI: TestAddPlayerUI!
    private var testPlayerManager: TestPlayerManager!
    private var addPlayerPresenterClosureWasCalled: Bool!
    private var addedPlayer: Player?

    override func setUp() {
        super.setUp()
        testAddPlayerUI = TestAddPlayerUI()
        testPlayerManager = TestPlayerManager()
        addedPlayer = nil
        addPlayerPresenterClosureWasCalled = false
        testObject = AddPlayerPresenter(ui: testAddPlayerUI, playerManager: testPlayerManager) { player in
            self.addPlayerPresenterClosureWasCalled = true
            self.addedPlayer = player
        }

    }

    override func tearDown() {
        testAddPlayerUI = nil
        testPlayerManager = nil
        testObject = nil

        super.tearDown()
    }

    /**
     *  Given:
     *  When:   View is dismissed
     *  Then:   The add player presenter closure should be called
     *  And:    No players should be returned in the closure
     */
    func testDismissView() {
        testObject.dismissView()
        XCTAssertTrue(addPlayerPresenterClosureWasCalled)
        XCTAssertNil(addedPlayer)
    }

    /**
     *  Given: No name has been entered
     *  When: Trying to create new player
     *  Then: An error should be returned
     */
    func testCreateNewPlayerWhenNameIsNil() {
        testObject.createNewPlayer(name: nil)
        XCTAssertTrue(testAddPlayerUI.showErrorWasCalled)
        XCTAssertEqual(testAddPlayerUI.error ?? [:], ["Title": "Missing Name", "Message": "You need to enter a name", "ButtonTitle": "OK"])
    }

    /**
     *  Given: Empty string has been entered
     *  When: Trying to create new player
     *  Then: An error should be returned
     */
    func testCreateNewPlayerWhenNameIsEmptyString() {
        testObject.createNewPlayer(name: "")
        XCTAssertTrue(testAddPlayerUI.showErrorWasCalled)
        XCTAssertEqual(testAddPlayerUI.error ?? [:], ["Title": "Missing Name", "Message": "You need to enter a name", "ButtonTitle": "OK"])
    }

    /**
     *  Given: Name has been entered
     *  When: Trying to create new player
     *  Then: Add player is called in the Player Manager
     *  And: The add player presenter closure should be called
     *  And: The new player should be returned in the closure
     */
    func testCreateNewPlayer() {
        testObject.createNewPlayer(name: "Linda")
        XCTAssertTrue(testPlayerManager.addPlayerWasCalled)
        XCTAssertTrue(addPlayerPresenterClosureWasCalled)
        XCTAssertEqual(addedPlayer?.id, "ID")
        XCTAssertEqual(addedPlayer?.name, "Linda")
    }
}

private class TestAddPlayerUI: AddPlayerUI {
    var error: [String: String]?
    var showErrorWasCalled = false

    func showError(title: String, message: String, buttonTitle: String) {
        showErrorWasCalled = true
        error = ["Title": title, "Message": message, "ButtonTitle": buttonTitle]
    }
}

private class TestPlayerManager: PlayerManager {
    var addPlayerWasCalled = false

    func addPlayer(name: String, avatar: Data) -> Player {
        addPlayerWasCalled = true
        return Player(id: "ID", name: name, avatar: avatar)
    }

    func updatePlayer(_: Player) throws { }

    func getAllPlayers() -> [Player] {
        return []
    }

    func removePlayer(_: Player) throws { }
}

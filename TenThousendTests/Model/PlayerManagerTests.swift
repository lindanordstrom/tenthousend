//
//  PlayerManagerTests.swift
//  TenThousendTests
//
//  Created by Yaser on 2018-01-26.
//  Copyright © 2018 YasLin. All rights reserved.
//

import XCTest

@testable import TenThousend

class PlayerManagerTests: XCTestCase {

    private var testObject: DicePlayerManager!
    private var dataStore: PlayerManagerTestUserDefaults!

    override func setUp() {
        super.setUp()
        dataStore = PlayerManagerTestUserDefaults()
        testObject = DicePlayerManager(dataStore: dataStore)
    }

    override func tearDown() {
        dataStore = nil
        testObject = nil

        super.tearDown()
    }

    /**
     *  Given: No players exists in storage
     *  When: New player is added
     *  Then: The added player is the only user in the list
     *  And:  The player has ID 1
     */
    func testAddPlayerWhileNoOtherPlayersExists() {
        testObject.addPlayer(name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer = Player(id: 1, name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayerList = [expectedPlayer]

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(dataStore.value as! [Player], expectedPlayerList)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: New player is added
     *  Then: The added player is appended to the list
     *  And:  The player gets next available ID
     */
    func testAddPlayerWhileOtherPlayersExists() {
        let expectedPlayer1 = Player(id: 1, name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: 2, name: "Yaser", avatar: Data(capacity: 1))
        var expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = expectedPlayerList

        testObject.addPlayer(name: "Pixel", avatar: Data(capacity: 1))
        let expectedPlayer3 = Player(id: 3, name: "Pixel", avatar: Data(capacity: 1))
        expectedPlayerList.append(expectedPlayer3)

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(dataStore.value as! [Player], expectedPlayerList)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: A player is updated
     *  Then: The updated player gets updated
     */
    func testUpdatePlayer() {
        let expectedPlayer1 = Player(id: 1, name: "Linda", avatar: Data(capacity: 1))
        var expectedPlayer2 = Player(id: 2, name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = expectedPlayerList

        testObject.updatePlayer(expectedPlayer1, name: "Linda is awesome", avatar: Data(capacity: 2))
        expectedPlayer2 = Player(id: 2, name: "Linda is awesome", avatar: Data(capacity: 2))

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(dataStore.value as! [Player], expectedPlayerList)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: Getting all players
     *  Then: A list of all players is returned
     */
    func testGetAllPlayers() {
        let expectedPlayer1 = Player(id: 1, name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: 2, name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayer3 = Player(id: 3, name: "Pixel", avatar: Data(capacity: 1))

        let expectedPlayerList = [expectedPlayer1, expectedPlayer2, expectedPlayer3]
        dataStore.value = expectedPlayerList

        let result = testObject.getAllPlayers()

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(result, expectedPlayerList)
    }

    /**
     *  Given: No players exists in storage
     *  When: Getting all players
     *  Then: An empty list is returned
     */
    func testGetAllPlayersWhenNoPlayersExists() {
        let result = testObject.getAllPlayers()

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(result, [])
    }

    /**
     *  Given: Previous players exists in storage
     *  When: A player is removed
     *  Then: The player is removed from the list
     */
    func testRemovePlayer() {
        let expectedPlayer1 = Player(id: 1, name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: 2, name: "Yaser", avatar: Data(capacity: 1))
        var expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = expectedPlayerList

        testObject.removePlayer(expectedPlayer1)
        expectedPlayerList.remove(at: 0)

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(dataStore.value as! [Player], expectedPlayerList)
    }

    /**
     *  Given: No previous players exists
     *  When: A player is removed
     *  Then: Set value for Key should not be called
     *  And: Nothing else should happen (no crash, no update)
     */
    func testRemovePlayerWhenNoPlayersExists() {
        let expectedPlayer1 = Player(id: 1, name: "Linda", avatar: Data(capacity: 1))
        testObject.removePlayer(expectedPlayer1)

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertFalse(dataStore.setValueForKeyCalled)
    }

}

class PlayerManagerTestUserDefaults: DataStore {
    var setValueForKeyCalled = false
    var objectForKeyCalled = false
    var key: String?
    var value: Any?

    func setValue(_ value: Any?, forKey key: String) {
        self.key = key
        self.value = value
        setValueForKeyCalled = true
    }

    func object(forKey defaultName: String) -> Any? {
        objectForKeyCalled = true
        key = defaultName
        return value
    }
}

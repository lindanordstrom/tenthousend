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

    private var testObject: PlayerManager!
    private var dataStore: TestUserDefaults!
    private var uniqueIdentifier: PlayerManagerTestUUID!

    override func setUp() {
        super.setUp()
        dataStore = TestUserDefaults()
        uniqueIdentifier = PlayerManagerTestUUID()
        testObject = DicePlayerManager(dataStore: dataStore, uniqueIdentifier: uniqueIdentifier)
    }

    override func tearDown() {
        dataStore = nil
        uniqueIdentifier = nil
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
        let expectedPlayer = Player(id: uniqueIdentifier.uuidString, name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayerList = [expectedPlayer]

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: dataStore.value as! Data) as? [Player] ?? []
        XCTAssertEqual(unarchivedObject.count, expectedPlayerList.count)
        XCTAssertEqual(unarchivedObject.last?.id, expectedPlayerList.last?.id)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: New player is added
     *  Then: The added player is appended to the list
     *  And:  The player gets next available ID
     */
    func testAddPlayerWhileOtherPlayersExists() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        var expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        testObject.addPlayer(name: "Pixel", avatar: Data(capacity: 1))
        let expectedPlayer3 = Player(id: uniqueIdentifier.uuidString, name: "Pixel", avatar: Data(capacity: 1))
        expectedPlayerList.append(expectedPlayer3)

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: dataStore.value as! Data) as? [Player] ?? []
        XCTAssertEqual(unarchivedObject.count, expectedPlayerList.count)
        XCTAssertEqual(unarchivedObject.last?.id, expectedPlayerList.last?.id)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: Players have been removed
     *  And: A new player is added
     *  Then: The added player is appended to the list
     *  And:  The player gets next available ID
     */
    func testAddPlayerWhileOtherPlayersExistsAndSomePlayersHaveBeenRemoved() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayer3 = Player(id: "c", name: "Pixel", avatar: Data(capacity: 1))
        var expectedPlayerList = [expectedPlayer1, expectedPlayer2, expectedPlayer3]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        guard let _ = try? testObject.removePlayer(expectedPlayer2) else {
            XCTFail("Error thrown")
            return
        }

        expectedPlayerList.remove(at: 1)

        testObject.addPlayer(name: "Peppen", avatar: Data(capacity: 1))
        let expectedPlayer4 = Player(id: uniqueIdentifier.uuidString, name: "Peppen", avatar: Data(capacity: 1))
        expectedPlayerList.append(expectedPlayer4)

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: dataStore.value as! Data) as? [Player] ?? []
        XCTAssertEqual(unarchivedObject.count, expectedPlayerList.count)
        XCTAssertEqual(unarchivedObject.last?.id, expectedPlayerList.last?.id)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: A player is updated
     *  Then: The updated player gets updated
     */
    func testUpdatePlayer() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        expectedPlayer1.name = "Linda is Awesome"
        expectedPlayer1.bestTurn = 5000
        expectedPlayer1.currentGameData = CurrentGameData(totalScore: 100, turns: 1, lastTurnScore: 100)

        guard let _ = try? testObject.updatePlayer(expectedPlayer1) else {
            XCTFail("Error thrown")
            return
        }

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: dataStore.value as! Data) as? [Player] ?? []
        XCTAssertEqual(unarchivedObject.count, expectedPlayerList.count)
        XCTAssertEqual(unarchivedObject.first?.name, expectedPlayerList.first?.name)
        XCTAssertEqual(unarchivedObject.first?.bestTurn, expectedPlayerList.first?.bestTurn)
        XCTAssertEqual(unarchivedObject.first?.currentGameData.totalScore, expectedPlayerList.first?.currentGameData.totalScore)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: A non existing player is updated
     *  Then: The update function throws an error
     */
    func testUpdateNonExistingPlayer() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        XCTAssertThrowsError(try testObject.updatePlayer(Player(id: "c", name: "Pixel", avatar: Data(capacity: 1)))) { (error) in
            XCTAssertEqual(error as? PlayerError, PlayerError.nonExistingPlayer)
        }

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertFalse(dataStore.setValueForKeyCalled)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: Getting all players
     *  Then: A list of all players is returned
     */
    func testGetAllPlayers() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayer3 = Player(id: "c", name: "Pixel", avatar: Data(capacity: 1))

        let expectedPlayerList = [expectedPlayer1, expectedPlayer2, expectedPlayer3]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        let result = testObject.getAllPlayers()

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        XCTAssertEqual(result.count, expectedPlayerList.count)
        XCTAssertEqual(result.last?.id, expectedPlayerList.last?.id)
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
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        var expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        guard let _ = try? testObject.removePlayer(expectedPlayer1) else {
            XCTFail("Error thrown")
            return
        }

        expectedPlayerList.remove(at: 0)

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertTrue(dataStore.setValueForKeyCalled)
        XCTAssertEqual(dataStore.key, "Players")
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: dataStore.value as! Data) as? [Player] ?? []
        XCTAssertEqual(unarchivedObject.count, expectedPlayerList.count)
        XCTAssertEqual(unarchivedObject.last?.id, expectedPlayerList.last?.id)
    }

    /**
     *  Given: No previous players exists
     *  When: A player is removed
     *  Then: Set value for Key should not be called
     *  And: Nothing else should happen (no crash, no update)
     */
    func testRemovePlayerWhenNoPlayersExists() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))

        XCTAssertThrowsError(try testObject.removePlayer(expectedPlayer1)) { (error) in
            XCTAssertEqual(error as? PlayerError, PlayerError.emptyPlayerList)
        }

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertFalse(dataStore.setValueForKeyCalled)
    }

    /**
     *  Given: Previous players exists in storage
     *  When: A non existing player is removed
     *  Then: Set value for Key should not be called
     *  And: An error should be thrown
     *  And: Nothing else should happen (no crash, no update)
     */
    func testRemoveNonExistingPlayer() {
        let expectedPlayer1 = Player(id: "a", name: "Linda", avatar: Data(capacity: 1))
        let expectedPlayer2 = Player(id: "b", name: "Yaser", avatar: Data(capacity: 1))
        let expectedPlayerList = [expectedPlayer1, expectedPlayer2]
        dataStore.value = NSKeyedArchiver.archivedData(withRootObject: expectedPlayerList as NSArray) as NSData

        XCTAssertThrowsError(try testObject.removePlayer(Player(id: "c", name: "Pixel", avatar: Data(capacity: 1)))) { (error) in
            XCTAssertEqual(error as? PlayerError, PlayerError.nonExistingPlayer)
        }

        XCTAssertTrue(dataStore.objectForKeyCalled)
        XCTAssertFalse(dataStore.setValueForKeyCalled)
    }

}

class TestUserDefaults: DataStore {
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

class PlayerManagerTestUUID: UniqueIdentifier {
    var uuidString: String = "123"
}

extension Player: Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        return
                lhs.name == rhs.name &&
                lhs.avatar == rhs.avatar &&
                lhs.currentGameData == rhs.currentGameData &&
                lhs.bestTurn == rhs.bestTurn &&
                lhs.quickestVictory == rhs.quickestVictory
    }
}

extension CurrentGameData: Equatable {
    public static func == (lhs: CurrentGameData, rhs: CurrentGameData) -> Bool {
        return
            lhs.lastTurnScore == rhs.lastTurnScore &&
                lhs.totalScore == rhs.totalScore &&
                lhs.turns == rhs.turns
    }
}

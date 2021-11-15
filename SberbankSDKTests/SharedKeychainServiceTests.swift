//
//  SharedKeychainServiceTests.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
@testable import SberbankSDK

final class SharedKeychainServiceTests: XCTestCase {

	let keychain = KeychainWrapperMock()
	lazy var sharedKeychain = SharedKeychainService(keychainWrapper: keychain)

	override func tearDown() {
		super.tearDown()
		keychain.clearMock()
	}

	func testSharedKeychainServiceInitsCorrectly() {
		//Arrange
		let appIdPrefix = Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix") as? String ?? ""

		// Act
		let sharedKeychain = SharedKeychainService(keychainWrapper: keychain)

		// Assert
		XCTAssert(sharedKeychain.appIdKey == "AppIdentifierPrefix")
		XCTAssert(sharedKeychain.keychainGroupEnding == "ru.sberbank.onlineiphone.shared")
		XCTAssert(sharedKeychain.sharedKeychainGroup == appIdPrefix + "ru.sberbank.onlineiphone.shared")
	}

	func testSaveMaskedNameByCorrectKey() {
		//Arrange
		let name = "name"
		let usersData = PersonalizedButtonData(maskedName: name).jsonData ?? Data()
		let expectedKey = DataToStore.personalizedButtonData.rawValue

		// Act
		sharedKeychain.savePersonalizedButtonData(usersData)

		// Assert
		XCTAssert(keychain.query[kSecAttrService.string] as? String == expectedKey)
		XCTAssert(keychain.query[kSecClass.string] as? String == kSecClassGenericPassword.string)
		XCTAssert(keychain.query[kSecValueData.string] as? Data == usersData)
		XCTAssert(keychain.query[kSecAttrAccessible.string] as? String ==
			kSecAttrAccessibleWhenUnlockedThisDeviceOnly.string)
	}

	func testGetPersonalizedButtonMaskedNameUsesSpecificQueryAndReturnsValue() {
		//Arrange
		let expectedKey = DataToStore.personalizedButtonData.rawValue
		let data = PersonalizedButtonData(maskedName: "name").jsonData
		keychain.keychainResult = KeychainResult(status: 0,
												 queryResult: data as AnyObject?)

		// Act
		let result = sharedKeychain.getPersonalizedButtonMaskedName()

		// Assert
		XCTAssert(result == "name")
		XCTAssert(keychain.query[kSecAttrService.string] as? String == expectedKey)
		XCTAssert(keychain.query[kSecMatchLimit.string] as? String == kSecMatchLimitOne.string)
		XCTAssert(keychain.query[kSecClass.string] as? String == kSecClassGenericPassword.string)
		XCTAssert(keychain.query[kSecAttrAccessible.string] as? String ==
			kSecAttrAccessibleWhenUnlockedThisDeviceOnly.string)
	}

	func testDeletePersonalizedButtonDataUsesSpecificQuery() {
		//Arrange
		let expectedKey = DataToStore.personalizedButtonData.rawValue

		// Act
		sharedKeychain.deletePersonalizedButtonData()

		// Assert
		XCTAssert(keychain.query[kSecAttrService.string] as? String == expectedKey)
		XCTAssert(keychain.query[kSecClass.string] as? String == kSecClassGenericPassword.string)
		XCTAssert(keychain.query[kSecAttrAccessible.string] as? String ==
			kSecAttrAccessibleWhenUnlockedThisDeviceOnly.string)
	}
}

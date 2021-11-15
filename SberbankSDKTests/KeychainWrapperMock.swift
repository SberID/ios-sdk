//
//  KeychainWrapperMock.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 16.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
@testable import SberbankSDK

final class KeychainWrapperMock: KeychainWrapperProtocol {

	var osStatus: OSStatus = 0
    var query: [String: AnyObject] = [:]
    var keychainResult = KeychainResult(status: 0, queryResult: nil)

	func get(_ query: [String: NSObject]) -> KeychainResult? {
		self.query = query
        return keychainResult
	}

	func save(_ query: [String: NSObject]) -> OSStatus {
		self.query = query
        return osStatus
	}

	func delete(_ query: [String: NSObject]) -> OSStatus {
		self.query = query
        return osStatus
	}

	func clearMock() {
        query = [:]
        osStatus = 0
        keychainResult = KeychainResult(status: 0, queryResult: nil)
    }
}


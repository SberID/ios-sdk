//
//  KeychainWrapper.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation
import UIKit

/// Протокол обертки над системными вызовами работы с keychain
protocol KeychainWrapperProtocol {

	/// Получить данные, соответствующие запросу
	/// - Parameter query: запрос
	func get(_ query: [String: NSObject]) -> KeychainResult?

	/// Сохранить данные в keychain
	/// - Parameter query: запрос
	func save(_ query: [String: NSObject]) -> OSStatus

	/// Удалить данные из keychain
	/// - Parameter query: запрос
	func delete(_ query: [String: NSObject]) -> OSStatus
}

/// Класс обертка над системными вызовами работы с keychain
final class KeychainWrapper: NSObject, KeychainWrapperProtocol {

	func get(_ query: [String: NSObject]) -> KeychainResult? {
		var queryResult: AnyObject?
		let status = withUnsafeMutablePointer(to: &queryResult) {
			SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
		}
		return KeychainResult(status: status, queryResult: queryResult)
	}

	func save(_ query: [String: NSObject]) -> OSStatus {
		return SecItemAdd(query as CFDictionary, nil)
	}

	func delete(_ query: [String: NSObject]) -> OSStatus {
		return SecItemDelete(query as CFDictionary)
	}
}

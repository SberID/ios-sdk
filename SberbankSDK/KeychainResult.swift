//
//  KeychainResult.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

/// Результат работы с keychain
final class KeychainResult: NSObject {

	/// Status code
	var status: OSStatus
	/// Результат запроса
	var queryResult: AnyObject?

	init(status: OSStatus, queryResult: AnyObject?) {
		self.status = status
		self.queryResult = queryResult
	}
}

//
//  Bundle+extension.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 17.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

extension Bundle {

	static private let sdkBundleName = "ru.sberbank.sdk.SberbankSDK"

	static func sdkBundle() -> Bundle {
		let sdkBundle = Bundle(identifier: sdkBundleName)
		return sdkBundle ?? Bundle.main
	}

	/// Текущая версия приложения в которое встроен СДК
    var version: String {
		guard let versionString = infoDictionary?["CFBundleShortVersionString"] as? String else { return String() }
		let resultedString = "ios \(versionString)"
        return resultedString
    }

	/// Текущий билд приложения в которое встроен СДК
    var build: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? String()
    }

	/// Название таргета приложения, в которое встроен СДК
	var targetName: String {
		infoDictionary?["CFBundleName"] as? String ?? String()
	}

	/// Название приложения, в которое встроен СДК
	var displayName: String {
		infoDictionary?["CFBundleDisplayName"] as? String ?? String()
	}
}

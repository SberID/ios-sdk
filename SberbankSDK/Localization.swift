//
//  Localization.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 11.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

/// "Переводчик"
final class Lang {

	/// Возвращает локализованный вариант текста
	/// - Parameter key: ключ по которому искать в файлах локализации
	/// - Returns: локализованную строку
	static func localize(_ key: String) -> String {
		return Bundle.sdkBundle().localizedString(forKey: key, value: nil, table: nil)
	}
}

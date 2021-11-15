//
//  String+extension.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 10.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

extension String {

	/// Возвращает URL, если это возможно
	var url: URL? { URL(string: self) }

	/// Возвращает true, если строка закодирована percentEncoding-ом
	var isPercentEncoded: Bool {
		let decodedString = self.removingPercentEncoding
		return self != decodedString
	}
	
	/// Заменяет + на -, / на _, обрезает = в конце строки
	func replaceURLSymbolsAndUndesiredEnding() -> String {
		var result = self.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
		result = result.trimmingCharacters(in: CharacterSet(charactersIn: "="))
		return result
	}

	/// Декодирует строку, если она была закодирована percentEncoding-ом
	/// - Returns: декодированая строка
	func removePercentEncodingIfEncoded() -> String {
		let result = self.isPercentEncoded ? self.removingPercentEncoding : self
		return result ?? self
	}
}

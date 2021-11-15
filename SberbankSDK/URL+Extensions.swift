//
//  URL+Extensions.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 02.06.2021.
//  Copyright © 2021 Sberbank. All rights reserved.
//

import Foundation

extension URL {

	/// Сравнивает URL-ы по схеме, параметрам, хосту
	/// - Parameter url: URL с которым сравнивать
	/// - Returns: true, если схема, параметры(не зависимо от последовательности) и хост совпадают
	func isSimilarTo(url: URL?) -> Bool {
		guard let url = url,
			let queryItemsFromUrl = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
			let queryItemsFromSelf = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems,
			let componentsFromUrl = URLComponents(url: url, resolvingAgainstBaseURL: false),
			let componentsFromSelf = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return false }

		let queryItemsAreEqual = queryItemsFromSelf.count == queryItemsFromUrl.count &&
								 queryItemsFromUrl.filter{ !queryItemsFromSelf.contains($0) }.isEmpty
		let hostsEqual = componentsFromSelf.host == componentsFromUrl.host
		let schemesEqul = componentsFromSelf.scheme == componentsFromUrl.scheme
		return hostsEqual && schemesEqul && queryItemsAreEqual
	}

	/// Возвращает значение для параметра из URL-запроса
	/// - Parameter queryParamaterName: название параметра
	/// - Returns: значение для указанного параметра
	func valueForParameterKey(_ queryParamaterName: String) -> String? {
		guard let url = URLComponents(string: self.absoluteString) else { return nil }
		return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
	}

	/// Словарь с параметрами запроса
	var queryParameters: [String: String]? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			  let queryItems = components.queryItems else { return nil }
		return queryItems.reduce(into: [String: String]()) { (result, item) in
			result[item.name] = item.value
		}
	}
}

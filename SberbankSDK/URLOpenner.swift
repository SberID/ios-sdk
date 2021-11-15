//
//  URLOpenner.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

/// Входной протокол для сервиса открытия сылок
protocol URLOpennerInput {

	/// Открыть ссылку
	/// - Parameters:
	///   - url: ссылка
	///   - options: параметры
	///   - completion: блок запершения
	func openURL(url: URL,
				 options: [UIApplication.OpenExternalURLOptionsKey: Any],
				 completion: ((Bool) -> Void)?)

	/// Проверить если ли возможность открыть URL
	/// - Parameter urlString: URL-строка
	/// - Returns: true, если можно открыть установленное приложение
	func canOpenUrl(urlString: String) -> Bool

	/// Проверить если ли возможность открыть URL
	/// - Parameter url: URL
	func canOpenUrl(_ url: URL) -> Bool
}

/// Открыватель ссылок (сторонних приложений), обертка над UIApplication
final class URLOpenner: URLOpennerInput {

	func openURL(url: URL,
				 options: [UIApplication.OpenExternalURLOptionsKey : Any],
				 completion: ((Bool) -> Void)? = nil) {
		UIApplication.shared.open(url, options: options, completionHandler: completion)
	}

	func canOpenUrl(urlString: String) -> Bool {
		guard let url = URL(string: urlString) else { return false }
		return UIApplication.shared.canOpenURL(url)
	}

	func canOpenUrl(_ url: URL) -> Bool {
		return UIApplication.shared.canOpenURL(url)
	}
}



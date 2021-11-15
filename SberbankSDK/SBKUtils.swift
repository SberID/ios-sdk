//
//  SBKUtils.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation
import CommonCrypto

/// Метод хэширования
public let SBKUtilsCodeChallengeMethod = "S256"

/// Вспомогательные утилиты
@objc public final class SBKUtils: NSObject {

	static let ssoRedirectUrlQueryKey = "sberIDRedirect"

	/// Создает и возвращает случайно сгенерированную строку
	/// - Returns: случайное сгенерированная строка
	@objc public static func createVerifier() -> String {
		// Случайное число от 32 до 96
		let dataLenght = Int(arc4random_uniform(65) + 32)
		let data = NSMutableData(length: dataLenght) ?? NSMutableData()
		_ = SecRandomCopyBytes(kSecRandomDefault, dataLenght, data.mutableBytes)
		return createVerifierForData(data as Data)
	}

	/// Создает и возвращает хэшированную строку из переданной секретной строки
	/// - Parameter verifier: секретная случайно сгенерированная строка
	/// - Returns: хэшированная строка
	@objc public static func createChallenge(_ verifier: String) -> String {
		return sha256(verifier).replaceURLSymbolsAndUndesiredEnding()
	}

	/// Получить базовую URL-строку из исходного URL при переходе в МП партнера в сценарии бесшовной авторизаии.
	/// Полученное значение необходимо передать при создании SBKAuthRequest в параметр ТАКОЙ-ТО.
	/// - Parameter from: исходный URL, по которому был осуществленпри переходе в МП партнера при бесшовной авторизации.
	/// - Returns: URL-строка
	@objc public static func getSSOUrlStringFrom(_ url: URL?) -> String? {
		guard let url = url,
			  let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
			  let ssoUrlParameterString = components.queryItems?.first(where: {
					$0.name.lowercased() == ssoRedirectUrlQueryKey.lowercased()
				})?.value?.removePercentEncodingIfEncoded(),
			  let ssoUrl = ssoUrlParameterString.url,
			  var ssoUrlComponents = URLComponents(url: ssoUrl, resolvingAgainstBaseURL: false) else { return nil }

		ssoUrlComponents.queryItems = nil
		return ssoUrlComponents.string
	}

	// MARK: - Private

	static private func sha256(_ str: String) -> String {
		guard let data = str.data(using: String.Encoding.utf8) else { return "" }

		let shaData = sha256(data: data)
		let resultedString = shaData.base64EncodedString(options: [])
		return resultedString
	}

	static private func sha256(data : Data) -> Data {
		/// Создаем беззнаковый 8ми битное interer число которое состоит из 32х нулей
		/// #define CC_SHA256_DIGEST_LENGTH     32
		var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

		/// Вычисление дайджеста и помещает результат в буфер(переменная hash)
		data.withUnsafeBytes {
			_ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
		}
		return Data(hash)
	}

	static internal func createVerifierForData(_ data: Data) -> String {
		return data.base64EncodedString(options: []).replaceURLSymbolsAndUndesiredEnding()
	}
}

//
//  SBKAuthRequest.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

/// Модель запроса
@objcMembers public final class SBKAuthRequest: NSObject {

	public static let challengeMethod = SBKUtilsCodeChallengeMethod

	/// Идентификатор клиента
	public var clientId: String

	/// Наименование групп данных, на которые подписана система
	public var scope: String

	/// Значение для предотвращения подделки межсайтовых запросов, случайно сгенерированное
	public var state: String

	/// Значение, сгенерированное внешней АС для предотвращения атак повторения
	public var nonce: String

	/// Адрес на который будет перенаправлен клиент после успешной аутентификации (deeplink)
	public var redirectUri: String

	/// URI, который будет использован для запуска авторизации взамен дефолтного
	public var ssoBaseUrl: String?

	/// Хэшированное значение секретного кода
	public var codeChallenge: String?

	/// Метод преобразования секретного кода
	public var codeChallengeMethod: String?

	/// Инициализатор
	/// - Parameters:
	///   - clientId: Идентификатор клиента
	///   - scope: Наименование групп данных, на которые подписана система
	///   - state: Значение для предотвращения подделки межсайтовых запросов, случайно сгенерированное
	///   - nonce: Значение, сгенерированное внешней АС для предотвращения атак повторения
	///   - ssoBaseUrl: Url для отправки запроса, если nil - будет исопльзовано значение по умолчанию
	///   - redirectUri: Url на который будет перенаправлен клиент после успешной аутентификации (deeplink)
	///   - codeChallenge: Хэшированное значение секретного кода
	///   - codeChallengeMethod: Метод преобразования секретного кода
	public init(clientId: String,
		 scope: String,
		 state: String,
		 nonce: String,
		 ssoBaseUrl: String?,
		 redirectUri: String,
		 codeChallenge: String?,
		 codeChallengeMethod: String?) {

		self.clientId = clientId
		self.scope = scope
		self.state = state
		self.nonce = nonce
		self.ssoBaseUrl = ssoBaseUrl
		self.redirectUri = redirectUri
		self.codeChallenge = codeChallenge
		self.codeChallengeMethod = codeChallengeMethod
	}

	/// Инициализатор. Инициирует
	/// clientId, scope, state, nonce, redirectUri, codeChallenge, codeChallengeMethod - пустыми строками
	/// ssoBaseUrl - nil
	public override init() {
		self.clientId = ""
		self.scope = ""
		self.state = ""
		self.nonce = ""
		self.redirectUri = ""
		self.ssoBaseUrl = nil
		self.codeChallenge = ""
		self.codeChallengeMethod = ""
	}
}


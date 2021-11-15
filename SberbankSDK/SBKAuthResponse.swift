//
//  SBKAuthResponse.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

/// Объект ответа авторизации
@objcMembers public final class SBKAuthResponse: NSObject {

	/// Значение, сгенерированное внешней АС для предотвращения атак повторения
	public private(set) var nonce: String

	/// Значение для предотвращения подделки межсайтовых запросов, случайно сгенерированное
	public private(set) var state: String?

	/// Код авторизации клиента
	public private(set) var authCode: String?

	/// Текст ошибки
	public private(set) var error: String?

	/// Статус операции
	public private(set) var isSuccess: Bool

	init(success: Bool, nonce: String, state: String?, authCode: String?, error: String?) {
		self.nonce = nonce
		self.state = state
		self.error = error
		self.authCode = authCode
		self.isSuccess = success
	}
}

//
//  AuthManagerConstants.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

/// Константы
final class AuthManagerConstants {

	// Ключи параметров запроса
	static let AuthRequestClientId = "client_id"
	static let AuthRequestState = "state"
	static let AuthRequestNonce = "nonce"
	static let AuthRequestScope = "scope"
	static let AuthRequestRedirectUri = "redirect_uri"
	static let AuthRequestCodeChallenge = "code_challenge"
	static let AuthRequestCodeChallengeMethod = "code_challenge_method"
	static let AuthRequestResponseType = "response_type"
	static let AuthRequestResponseTypeValue = "code"

	// Ключи параметров запроса для авторизации через единую web-страницу
	static let soleWebAuthRequestAppRedirectUri = "app_redirect_uri"
	static let soleWebAuthRequestAuthApp = "authApp"

	// Ключи параметров ответа
	static let AuthResponseState = "state"
	static let AuthResponseError = "error"
	static let AuthResponseAuthCode = "code"

	// Ошибки
	static let AuthManagerInternalError = "internal_error"
	static let AuthManagerInvalidState = "invalid_state"

	// Urls
	static let AuthManagerDeeplink = "sberbankidexternallogin://sberbankid"
	static let AuthManagerURL = "https://online.sberbank.ru/CSAFront/oidc/authorize.do"

	// Значения параметров
	static let soleWebAuthSBOLAuthApp = "sbol"
}

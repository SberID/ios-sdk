//
//  AuthUrlBuilder.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 21.06.2021.
//  Copyright © 2021 Sberbank. All rights reserved.
//

import Foundation

final class AuthUrlBuilder {

	private var baseUrlString: String?
	private var queryItems: [String: String] = [:]

	func setBaseUrlTo(_ urlString: String) {
		baseUrlString = urlString
	}

	func setParamsFrom(_ request: SBKAuthRequest) {
		queryItems[AuthManagerConstants.AuthRequestClientId] = request.clientId
		queryItems[AuthManagerConstants.AuthRequestState] = request.state
		queryItems[AuthManagerConstants.AuthRequestNonce] = request.nonce
		queryItems[AuthManagerConstants.AuthRequestScope] = request.scope
		queryItems[AuthManagerConstants.AuthRequestRedirectUri] = request.redirectUri

		if let codeChallenge = request.codeChallenge,
		   let codeChallengeMethod = request.codeChallengeMethod,
		   !codeChallenge.isEmpty && !codeChallengeMethod.isEmpty {
			queryItems[AuthManagerConstants.AuthRequestCodeChallenge] = request.codeChallenge
			queryItems[AuthManagerConstants.AuthRequestCodeChallengeMethod] = request.codeChallengeMethod
		}
	}

	func setCodeResponseType() {
		queryItems[AuthManagerConstants.AuthRequestResponseType] = AuthManagerConstants.AuthRequestResponseTypeValue
	}

	func setSoleWebPageParams(svcRedirectUrlString: String, sbolExists: Bool) {
		if sbolExists {
			queryItems[AuthManagerConstants.soleWebAuthRequestAppRedirectUri] = svcRedirectUrlString
			queryItems[AuthManagerConstants.soleWebAuthRequestAuthApp] = AuthManagerConstants.soleWebAuthSBOLAuthApp
		}
	}

	func build() -> URL? {
		guard let baseUrlString = baseUrlString,
			  var components = URLComponents(string: baseUrlString) else { return nil }

		components.queryItems = queryItemsFrom(parameters: queryItems)
		return components.url
	}

	// MARK: Private

	func queryItemsFrom(parameters: [String: String]) -> [URLQueryItem] {
		return parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
	}
}

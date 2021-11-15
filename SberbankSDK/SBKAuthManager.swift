//
//  SBKAuthManager.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation
import SafariServices

/// Менеджер авторизации
@objc public final class SBKAuthManager: NSObject {

	/// NavigatioController необходимый для открытия SafariViewController, если у пользователя не установлено
	/// приложение "Сбербанк Онлайн"
	public static var navigationController: UINavigationController?

	/// Авторизоваться с помощью Сбербанк Онлайн
	/// - Parameter request: модель запроса
	@objc public static func auth(withSberId request: SBKAuthRequest) {
		let authService = AuthService(urlOpenner: URLOpenner())
		return authService.startAuth(request: request, navigationController: navigationController)
	}

	/// Запуск авторизации пользователя по Сбер ID, используя единое веб окно авторизации.
	/// - Parameter sberIdRequest: модель запроса
	/// - Parameter request: модель запроса
	/// - Parameter svcRedirectUrlString: URL для возврата из СБОЛа в МП партнера на откртый SVC
	///   со страницей единого портала авторизации
	/// - Returns: статус успеха запуска авторизации
	@objc public static func soleLoginWebPageAuth(sberIdRequest request: SBKAuthRequest,
												  svcRedirectUrlString: String) -> Bool {
		guard let navigationController = navigationController else { return false }
		let authService = AuthService(urlOpenner: URLOpenner())
		return authService.startSoleLoginWebPageAuth(request: request,
													 svcRedirectUrlString: svcRedirectUrlString,
													 navigationController: navigationController)
	}

	/// Получить объект ответа
	/// - Parameters:
	///   - url: url с которого был переход
	///   - completion: блок, возвращающий объект ответа
	@objc public static func getResponseFrom(_ url: URL, completion: (SBKAuthResponse) -> Void) {
		guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }

		let parameters = parametersFrom(queryItems: components.queryItems)

		let state = parameters[AuthManagerConstants.AuthResponseState]
		let nonce = StaticStorage.nonce ?? ""
		var error = parameters[AuthManagerConstants.AuthResponseError]
		let authCode = parameters[AuthManagerConstants.AuthResponseAuthCode]

		let success = isStateOK(state: state) && !(authCode?.isEmpty ?? (authCode == nil))

		if !isStateOK(state: state) {
			error = AuthManagerConstants.AuthManagerInvalidState
		}

		if authCode?.isEmpty ?? (authCode == nil) {
			error = AuthManagerConstants.AuthManagerInternalError
		}

		let response = SBKAuthResponse(success: success,
									nonce: nonce,
									state: state,
									authCode: authCode,
									error: error)
		sendAnalyticsDataFor(result: response)
		completion(response)
		StaticStorage.state = nil
		StaticStorage.nonce = nil
	}

	// MARK: Private

	static func parametersFrom(queryItems: [URLQueryItem]?) -> [String: String] {
		guard let queryItems = queryItems else { return [:] }
		var parameters = [String: String]()
		queryItems.forEach {
			if let value = $0.value {
				parameters[$0.name] = value
			}
		}
		return parameters
	}

	static func isStateOK(state: String?) -> Bool {
		StaticStorage.state == state
	}

	static func sendAnalyticsDataFor(result: SBKAuthResponse) {
		let eventData = SDKAnalyticsEventData.makeDataForLoginAuthResultEvent(result: result)
		StaticStorage.analyticsService.sendEvent(.sberIDLoginAuthResult,
												 by: StaticStorage.analyticsService.eventTracker,
												 properties: eventData.paramsAsADictionary())
		print("""
			\n✅👁👁 Analytics prepared. \(AnalyticsEventType.sberIDLoginAuthResult.rawValue).\n\
			Params: \(eventData.paramsAsADictionary())
			""")
	}

	private static func openAuthorizationDestination(urlWithOidcParameters: URL) {
		let urlOpenner = URLOpenner()
		if urlOpenner.canOpenUrl(urlWithOidcParameters) {
			urlOpenner.openURL(url: urlWithOidcParameters, options: [:], completion: nil)
		} else if let navigationController = navigationController {
			let viewController = SFSafariViewController(url: urlWithOidcParameters)
			navigationController.present(viewController, animated: false, completion: nil)
		}
	}
}

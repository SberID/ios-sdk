//
//  AuthService.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 21.06.2021.
//  Copyright © 2021 Sberbank. All rights reserved.
//

import UIKit
import Foundation
import SafariServices

/// Сервис авторизации по Сбер ID
final class AuthService {

	private let urlOpenner: URLOpennerInput

	/// Инициализатор
	/// - Parameter urlOpenner: сервис работы с URL и его открытия
	init(urlOpenner: URLOpennerInput) {
		self.urlOpenner = urlOpenner
	}

	/// Запуск авторизации пользователя по Сбер ID
	/// - Parameters:
	///   - request: модель запроса
	///   - navigationController: NavigationController для открытия SVC при необходимости
	func startAuth(request: SBKAuthRequest, navigationController: UINavigationController?) {
		StaticStorage.state = request.state
		StaticStorage.nonce = request.nonce

		let urlStringForRequest = request.ssoBaseUrl ?? AuthManagerConstants.AuthManagerDeeplink

		let urlBuilder = AuthUrlBuilder()
		urlBuilder.setBaseUrlTo(defineAuthorizationDestination(for: urlStringForRequest))
		urlBuilder.setParamsFrom(request)
		if !urlOpenner.canOpenUrl(urlString: urlStringForRequest) {
			urlBuilder.setCodeResponseType()
		}

		guard let authUrl = urlBuilder.build() else { return }
		openAuthorizationDestination(urlWithOidcParameters: authUrl, navigationController: navigationController)
	}

	/// Запуск авторизации пользователя по Сбер ID, используя единое веб окно авторизации.
	/// - Parameters:
	///   - request: модель запроса
	///   - svcRedirectUrlString: URL для возврата из СБОЛа в МП партнера на откртый SVC
	///   со страницей единого портала авторизации
	///   - navigationController: NavigatioController необходимый для открытия SafariViewController,
	///   если у пользователя не установлено приложение "Сбербанк Онлайн"
	/// - Returns: статус успеха запуска авторизации
	func startSoleLoginWebPageAuth(request: SBKAuthRequest,
								   svcRedirectUrlString: String,
								   navigationController: UINavigationController) -> Bool {
		StaticStorage.state = request.state
		StaticStorage.nonce = request.nonce

		let urlBuilder = AuthUrlBuilder()
		urlBuilder.setParamsFrom(request)
		urlBuilder.setCodeResponseType()
		urlBuilder.setSoleWebPageParams(svcRedirectUrlString: svcRedirectUrlString, sbolExists: isSBOLExists())
		urlBuilder.setBaseUrlTo(AuthManagerConstants.AuthManagerURL)

		guard let authUrl = urlBuilder.build() else { return false }
		openSafariViewController(for: authUrl, inNavigationController: navigationController)
		return true
	}

	// MARK: Private
	
	private func openAuthorizationDestination(urlWithOidcParameters: URL,
											  navigationController: UINavigationController?) {
		if urlOpenner.canOpenUrl(urlWithOidcParameters) {
			urlOpenner.openURL(url: urlWithOidcParameters, options: [:], completion: nil)
		} else if let navigationController = navigationController {
			openSafariViewController(for: urlWithOidcParameters, inNavigationController: navigationController)
		}
	}

	private func openSafariViewController(for url: URL,
										  inNavigationController controller: UINavigationController) {
		let viewController = SFSafariViewController(url: url)
		controller.present(viewController, animated: false, completion: nil)
	}

	/// Проверяет, установлено ли МП СБОЛ на устройстве
	/// - Returns: true, если установлено
	private func isSBOLExists() -> Bool {
		guard let sbolDeeplink = URL(string: AuthManagerConstants.AuthManagerURL) else { return false }
		return urlOpenner.canOpenUrl(sbolDeeplink)
	}

	/// Определяет Url-строку, которую прилоежние партнера сможет открыть
	/// - Parameter deeplinkString: deeplink желаемый для открытия
	/// - Returns: Url-строка которую приложение партнера сможет открыть
	private func defineAuthorizationDestination(for deeplinkString: String) -> String {
		urlOpenner.canOpenUrl(urlString: deeplinkString) ? deeplinkString : AuthManagerConstants.AuthManagerURL
	}
}

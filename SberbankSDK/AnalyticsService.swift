//
//  AnalyticsService.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 17.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit
import MPAnalytics

protocol AnalyticsServiceProtocol {

	/// дефолтный EventTracker для отправки сообщения через него
	var eventTracker: EventTracker { get }

	/// Отправить данные аналитики
	/// - Parameters:
	///   - eventType: тип события
	///   - properties: параметры для отправки
	func sendEvent(_ eventType: AnalyticsEventType, by tracker: EventTracker, properties: [String: String])
}

/// Сервис отправки аналитики, обертка над MPAnalytics
final class AnalyticsService: AnalyticsServiceProtocol {

	/// дефолтный EventTracker для отправки сообщения через него
	lazy var eventTracker: EventTracker = {
		let urlString = "https://sve.online.sberbank.ru/metrics/partners"
		let apiKey = "da8570065d949a8a3ee551b99f31f7774909575e702289b2743fab0aad0ffe41"
		let partnerName = Bundle.main.displayName

		// Инициализация модели данных профиля и геолокации
		let deviceConfiguration = DeviceConfiguration(profile: Profile())

		/// Инициализация сетевого слоя для сервиса Sberlytics
		let networkService = AnalyticsNetworkService(apiKey: apiKey, url: urlString) { result in
			switch result {
			case .success(let httpResponse):
				print("\n✅👁📤 Send analytics status code: \(httpResponse.statusCode)\nFull network response:\n\(httpResponse)")
			case .failure(let error):
				print("\n❌👁📤 Send analytics error: \(error.localizedDescription)")
			}
		}

		// Получаем инстанс модуля аналитики
		let sberlytics: EventTracker = MPAnalytics(networkService: networkService,
												   deviceConfiguration: deviceConfiguration,
												   sberId: partnerName)
		return sberlytics
	}()

	/// Отправить данные аналитики
	/// - Parameters:
	///   - eventType: тип события
	///   - properties: параметры для отправки
	func sendEvent(_ eventType: AnalyticsEventType, by tracker: EventTracker, properties: [String: String]) {

		let storable: Bool = false
		let params = [String: String]()
		let properties: [String: String] = properties

		tracker.sendEvent(eventName: eventType.rawValue,
						  params: params,
						  properties: properties,
						  storable: storable,
						  location: nil) { analyticsError in
			if let error = analyticsError {
				print("\n❌👁👁 ERROR! Analytics data composition error: \(String(describing: error.localizedDescription))\n")
			}
		}
	}
}

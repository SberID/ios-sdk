//
//  SDKAnalyticsEventData.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 17.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

/// Набор данных для отправки аналитики
struct SDKAnalyticsEventData: Codable, Equatable {

	/// Наименование события (автоматически проставляется значением метрики)
	private(set) var eventAction: String

	/// Версия SDK
	private(set) var sdkVersion: String?

	/// Цвет кнопки
	var colorView: String?

	/// Высота кнопки
	var heightView: String?

	/// Ширина кнопки
	var widthView: String?

	/// Рассчитанная ширина кнопки (в пикселях)
	var measuredWidthView: String?

	/// Персонализированная кнопка (т.е. отображается Войти как [Имя Ф.])
	var personalView: String?

	/// Результат входа
	var result: String?

	/// Детализация ошибки в случае неудачного входа
	var errorDescription: String?

	/// Представление свойств в виде словаря типа [String: String]
	func paramsAsADictionary() -> [String: String] {
		guard let data = try? JSONEncoder().encode(self),
			  let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return [:] }

		return (json as? Dictionary<String, String>) ?? [:]
	}

	/// Внести в данные сведения о версии SDK
	mutating func addSdkVersion() {
		sdkVersion = Bundle.sdkBundle().version
	}

	/// Инициализатор
	/// - Parameter eventType: тип события
	init(eventType: AnalyticsEventType) {
		eventAction = eventType.rawValue
	}

	static func makeLoginShowEventData(buttonSettings: LoginButtonSettingsProtocol,
										  isButtonPersonalized: Bool) -> SDKAnalyticsEventData {
		var eventData = SDKAnalyticsEventData(eventType: .sberIDLoginShow)
		eventData.addSdkVersion()
		eventData.colorView = buttonSettings.backgroundColor == LoginButtonStyle.green ? "green" : "white"
		eventData.heightView = buttonSettings.height.description
		eventData.widthView = buttonSettings.width.description
		eventData.personalView = isButtonPersonalized ? "1" : "0"
		return eventData
	}

	static func makeDataForLoginAuthResultEvent(result: SBKAuthResponse) -> SDKAnalyticsEventData {
		var eventData = SDKAnalyticsEventData(eventType: .sberIDLoginAuthResult)
		eventData.result = result.isSuccess ? "1" : "0"
		eventData.errorDescription = result.error?.description
		return eventData
	}

	static func makeDataForWrongButtonSizeEvent(desiredWidth: CGFloat,
												measuredWidth: CGFloat) -> SDKAnalyticsEventData {
		var eventData = SDKAnalyticsEventData(eventType: .sberIDWrongButtonSize)
		eventData.measuredWidthView = measuredWidth.description
		eventData.widthView = desiredWidth.description
		return eventData
	}

	static func makeLoginButtonClickEventData(buttonSettings: LoginButtonSettingsProtocol,
												 isButtonPersonalized: Bool) -> SDKAnalyticsEventData {
		var eventData = SDKAnalyticsEventData(eventType: .sberIDLoginButtonClick)
		eventData.colorView = buttonSettings.backgroundColor == LoginButtonStyle.green ? "green" : "white"
		eventData.heightView = buttonSettings.height.description
		eventData.widthView = buttonSettings.width.description
		eventData.personalView = isButtonPersonalized ? "1" : "0"
		return eventData
	}
}

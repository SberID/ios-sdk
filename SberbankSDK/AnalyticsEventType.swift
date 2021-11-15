//
//  AnalyticsEventType.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 27.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

/// Тип событий возможных для отпрвки
enum AnalyticsEventType: String {

	/// У партнера встроена SDK Sber ID (c SDK SA) -> Клиент вошел в на ресурс партнера (мерча).
	case sberIDLoginShow = "SberID Login Show"

	/// У партнера встроена SDK Sber ID (c SDK SA) -> У партнера некорректно отображается кнопка Войти по Сбер ID
	case sberIDWrongButtonSize = "SberID Wrong Button Size"

	/// Клиент вошел в на ресурс партнера (мерча) -> У партнера встроена SDK Sber ID (c SDK SA) -> Клиент нажимает на кнопку Войти по Сбер ID
	case sberIDLoginButtonClick = "SberID Login Button Click"

	/// У партнера встроена SDK Sber ID (c SDK SA) -> Клиент получил результат авторизации для партнера(мерча)
	case sberIDLoginAuthResult = "SberID Login Auth Result"
}

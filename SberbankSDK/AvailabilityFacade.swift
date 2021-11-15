//
//  AvailabilityFacade.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

/// Протокол фасада доступности
protocol AvailabilityFacadeProtocol {

	/// Доступность функционала персонализированной кнопки
	var isPersonalizedButtonEnabled: Bool { get }
}

/// Фасад доступности
final class AvailabilityFacade: AvailabilityFacadeProtocol {

	var isPersonalizedButtonEnabled: Bool { true }
}

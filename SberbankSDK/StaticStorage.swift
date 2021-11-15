//
//  StaticStorage.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

/// Промежуточное хранение переменных
final internal class StaticStorage {

	/// Необходимо хранить и не утилизировать сервис аналитики,
	/// т.к. он работает асинхронно и выполняет отправку с задержкой
	static var analyticsService: AnalyticsServiceProtocol = AnalyticsService()
//	static var urlOpenner: URLOpennerInput = URLOpenner()
	static var state: String?
	static var nonce: String?
 }

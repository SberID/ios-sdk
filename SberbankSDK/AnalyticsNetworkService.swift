//
//  AnalyticsNetworkService.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 25.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation
import MPAnalytics

/// Протокол URLSession
protocol URLSessionProtocol {
    func dataTask(
		with request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

/// Cетевой слой для сервиса отправки аналитики
final class AnalyticsNetworkService: NetworkService {

	var apiKey: String
	var urlString: String

	private let urlSession: URLSessionProtocol
	private let completion: (Result<HTTPURLResponse, Error>) -> Void

	/// Иницилизатор сетеового слоя
	/// - Parameters:
	///   - apiKey: ваш Api Key.
	///   - url: ваш персональный URL, на который будут отправлятся события.
	///   - completion: коллбэк с `response` или `error`
	convenience init(apiKey: String,
					 url: String,
					 completion: @escaping (Result<HTTPURLResponse, Error>) -> Void) {
		self.init(apiKey: apiKey, url: url, urlSession: URLSession.shared, completion: completion)
	}

	/// Иницилизатор сетеового слоя
	/// - Parameters:
	///   - apiKey: ваш Api Key.
	///   - url: ваш персональный URL, на который будут отправлятся события.
	///   - urlSession: экземпляр сессии
	///   - completion: коллбэк с `response` или `error`
	init(apiKey: String,
		 url: String,
		 urlSession: URLSessionProtocol,
		 completion: @escaping (Result<HTTPURLResponse, Error>) -> Void) {
		self.apiKey = apiKey
		self.urlString = url
		self.urlSession = urlSession
		self.completion = completion
	}

	/// Отправляет события по указанному URL и Api Key
	/// - Parameters:
	///   - body: Тело события
	///   - completionHandler: completionHandler
	func send(body: Event.Body, completionHandler: @escaping (Result<HTTPURLResponse, Error>) -> Void) {

		guard let url = URL(string: urlString) else {
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")

		do {
			let encoder = JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			let data = try encoder.encode(body)
			request.httpBody = data
		} catch let error {
			completionHandler(.failure(error))
        }

		let task = urlSession.dataTask(with: request) { [weak self] _, response, error in
			if let error = error {
				self?.completion(.failure(error))
				return completionHandler(.failure(error))
			} else if let httpUrlResponse = response as? HTTPURLResponse {
				self?.completion(.success(httpUrlResponse))
				completionHandler(.success(httpUrlResponse))
			} else {
				self?.completion(.failure(SberbankSDKError.unknownError))
				return
			}
		}
		task.resume()
	}
}

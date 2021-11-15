//
//  PersonalizedButtonData.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

/// Данные для отображения персонализированной кнопки
struct PersonalizedButtonData: Encodable, Decodable {

	/// Маскированное имя пользователя
    let maskedName: String
}

extension PersonalizedButtonData {

	/// данные сконвертированные в Data
	var jsonData: Data? {
		try? JSONEncoder().encode(self)
	}
}

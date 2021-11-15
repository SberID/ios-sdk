//
//  LoginButtonSettings.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 10.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

/// Стиль кнопки
@objc public enum LoginButtonStyle: Int {

	/// Зеленая кнопка с белыми логотипом и текстом
	case green = 0

	/// Белая кнопка с зелеными логотипом и текстом
	case white
}

/// Тип текста для кнопки
@objc public enum LoginButtonTextType: Int {

	// "Сбер ID"
    case short = 0

	// "Войти по Сбер ID"
    case general

	// "Заполнить со Сбер ID"
    case filling

	// "Продолжить со Сбер ID"
    case pursue
}

/// Стиль скругления углов кнопки
@objc public enum CornerRadiusStyle: Int {

	// Отсутствует
	case no = 0

	// Радиус = 4
	case normal

	// Радиус = высота кнопки / 2
	case max
}

/// Настройки для кнопки
final class LoginButtonSettings: LoginButtonSettingsProtocol {

	var backgroundColor: LoginButtonStyle
	var desiredWidth: CGFloat
	var cornerRadius: CGFloat
	var borderWidth: CGFloat
	var borderColor: UIColor
	var titleColor: UIColor
	var logoName: String
	var logoSize: CGSize
	var fontSize: CGFloat
	var height: CGFloat
	var width: CGFloat

	/// Инициализатор
	/// - Parameter style: желаемый стиль кнопки
	init(_ style: LoginButtonStyle) {
		let greenStyle = style == LoginButtonStyle.green
		backgroundColor = style
		desiredWidth = 0
		cornerRadius =  greenStyle ? 4.0 : 4.0
		borderWidth = greenStyle ? 0 : 1.0
		borderColor = greenStyle ? .clear : .defaultBorder
		titleColor = greenStyle ? .white : .black
		logoName = greenStyle ? "logo-white" : "logo-green"
		logoSize = CGSize(width: 22, height: 22)
		fontSize = 14
		height = 0
		width = 0
	}

	/// Инициализатор с указанием всех параметров
	/// - Parameters:
	///   - backgroundColor: Цвет фона
	///   - cornerRadius: Радиус закругления углов
	///   - borderWidth: Ширина линии обводки
	///   - borderColor: Цвет линии обводки
	///   - titleColor: Цвет текста
	///   - logoName: Имя логотипа кнопки
	///   - logoSize: Размер логотипа
	///   - fontSize: Размер шрифта
	///   - height: Высота кнопки
	///   - width: Ширина кнопки
	init(backgroundColor: LoginButtonStyle,
		 cornerRadius: CGFloat,
		 desiredWidth: CGFloat,
		 borderWidth: CGFloat,
		 borderColor: UIColor,
		 titleColor: UIColor,
		 logoName: String,
		 logoSize: CGSize,
		 fontSize: CGFloat,
		 height: CGFloat,
		 width: CGFloat) {

		self.backgroundColor = backgroundColor
		self.desiredWidth = desiredWidth
		self.cornerRadius = cornerRadius
		self.borderWidth = borderWidth
		self.borderColor = borderColor
		self.titleColor = titleColor
		self.logoName = logoName
		self.logoSize = logoSize
		self.fontSize = fontSize
		self.height = height
		self.width = width
	}
}

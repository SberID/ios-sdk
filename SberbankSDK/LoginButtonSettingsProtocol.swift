//
//  LoginButtonSettingsProtocol.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 10.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

/// Протокол настроек для кнопки
protocol LoginButtonSettingsProtocol {

	/// Цвет фона
	var backgroundColor: LoginButtonStyle { get }

	/// Радиус закругления углов
	var cornerRadius: CGFloat  { get set}

	/// Ширина линии обводки
	var borderWidth: CGFloat  { get set}

	/// Цвет линии обводки
	var borderColor: UIColor  { get set}

	/// Цвет текста
	var titleColor: UIColor  { get set}

	/// Имя логотипа кнопки
	var logoName: String { get set}

	/// Размер логотипа
	var logoSize: CGSize   { get set}

	/// Размер шрифта
	var fontSize: CGFloat  { get set}

	/// Высота кнопки
	var height: CGFloat  { get set}

	/// Ширина кнопки
	var width: CGFloat  { get set}

	/// Запрошеная при создании кнопки ширина
	var desiredWidth: CGFloat { get set }
}

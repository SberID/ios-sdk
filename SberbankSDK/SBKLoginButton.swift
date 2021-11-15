//
//  SBKLoginButton.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 10.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

/// Кнопка "Войти по Сбер ID"
@objc public final class SBKLoginButton: UIButton {

	private(set) var isPersonalized = false
	private var textType: LoginButtonTextType
	private var settings: LoginButtonSettingsProtocol
	private let analyticsService = AnalyticsService()
	private let buttonTexts: [LoginButtonTextType: String] = [
		LoginButtonTextType.short: Lang.localize("  Сбер ID") ,
		LoginButtonTextType.general: Lang.localize("  Войти по Сбер ID") ,
		LoginButtonTextType.filling: Lang.localize("  Заполнить со Сбер ID") ,
		LoginButtonTextType.pursue: Lang.localize("  Продолжить со Сбер ID")
	]

	// MARK: Life cycle

	/// Инициализатор
	/// - Parameters:
	///   - type: стиль кнопки
	///   - textType: вариант текста
	///   - desiredHeight: желаемая высота кнопки
	///   - desiredWidth: желаемая ширина кнопки
	@objc public convenience init(type: LoginButtonStyle,
								  textType: LoginButtonTextType,
								  desiredHeight: CGFloat,
								  desiredWidth: CGFloat) {
		self.init()

		self.textType = textType
		settings = createStyle(type)
		settings.desiredWidth = desiredWidth

		settings.fontSize = 14
		settings.logoName = type == LoginButtonStyle.white ? "logo-green": "logo-white"
		settings.logoSize = CGSize(width: 16, height: 16)

		if (desiredHeight < 28) {
			settings.height = 28.0
		} else if (desiredHeight <= 34) {
			settings.height = desiredHeight <= 32 ? desiredHeight : 32
		} else if ((desiredHeight <= 50)) {
			settings.height = desiredHeight <= 48 ? desiredHeight : 48
			settings.logoSize = CGSize(width: 22, height: 22)
		} else {
			settings.height = desiredHeight <= 64 ? desiredHeight : 64
			settings.fontSize = 16
			settings.logoSize = CGSize(width: 26, height: 26)
		}
		let font = UIFont.systemFont(ofSize: settings.fontSize + 2)
		let textSize = buttonText().size(withAttributes: [.font: font])

		let minimalWidth = settings.logoSize.width * 3 + textSize.width
		settings.width = desiredWidth >= minimalWidth ? desiredWidth : minimalWidth
		if desiredWidth < minimalWidth {
			sendAnalyticsForEvent(.sberIDWrongButtonSize)
		}

		setupButtonWith(text: buttonText(), settings: settings)
		_ = attemptToPersonalize()
		sendAnalyticsForEvent(.sberIDLoginShow)
	}

	private override init(frame: CGRect) {
		textType = LoginButtonTextType.general
		settings = LoginButtonSettings(.white)
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Public

	/// Устанавливает стиль обводки
	/// - Parameter color: цвет
	@objc public func setBorderColor(_ color: UIColor) {
		settings.borderColor = color
		updateView()
	}

	/// Инициализатор
	/// - Parameter type: стиль кнопки
	@objc public convenience init(type: LoginButtonStyle) {
		self.init(type: type, textType: LoginButtonTextType.general, desiredHeight: 30, desiredWidth: 50)
	}

	/// Устанавливает степень скругления углов кнопки
	/// - Parameter radiusStyle: степень скругления
	@objc public func setCornerRadius(_ radiusStyle: CornerRadiusStyle) {
		switch (radiusStyle) {
		case .no:
			settings.cornerRadius = 0
		case .normal:
			settings.cornerRadius = 4
		case .max:
			settings.cornerRadius = settings.height / 2
		}
		updateView()
	}

	public override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
		super.sendAction(action, to: target, for: event)
		sendAnalyticsForEvent(.sberIDLoginButtonClick)
	}

	/// Персонализирует кнопку при наличии данных
	/// - Returns: true, если кнопка была персонализированна
	public func attemptToPersonalize() -> Bool {
		guard let maskedName = SharedKeychainService().getPersonalizedButtonMaskedName(),
			AvailabilityFacade().isPersonalizedButtonEnabled,
			textType != LoginButtonTextType.short,
			!maskedName.isEmpty else {
				setTitle(buttonText(), for: .normal)
				isPersonalized = false
				return false
		}

		var title = Lang.localize("  Войти как ")
		let nameOnlyTitle = "  " + maskedName.prefix(maskedName.count - 3)
		title = nameOnlyTitle.count > buttonText().count ? nameOnlyTitle : title + maskedName

		setTitle(title, for: .normal)
		isPersonalized = true
		return true
	}

	// MARK: Private

	private func setTitleTo(_ text: String) {
		setupButtonWith(text: text, settings: settings)
	}

	private func setupButtonWith(text: String, settings: LoginButtonSettingsProtocol) {
		titleLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)
		setTitle(text, for: .normal)
		contentEdgeInsets = UIEdgeInsets(top: 0, left: settings.logoSize.width, bottom: 0, right: settings.logoSize.width)
		updateView()
	}

	private func updateView() {
		titleLabel?.lineBreakMode = .byTruncatingTail
		layer.cornerRadius = settings.cornerRadius
		backgroundColor = settings.backgroundColor == .green ? .brand : .white
		layer.borderColor = settings.borderColor.cgColor
		layer.borderWidth = settings.borderWidth

		let image = imageNamed(imageName: settings.logoName)?.scaleToSize(size: settings.logoSize)
		setImage(image, for: .normal)
		setImage(image, for: .highlighted)
		setTitleColor(settings.titleColor, for: .normal)

		self.translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: settings.width).isActive = true
		heightAnchor.constraint(equalToConstant: settings.height).isActive = true
	}

	private func createStyle(_ style: LoginButtonStyle) -> LoginButtonSettingsProtocol {
		return LoginButtonSettings(style)
	}

	private func imageNamed(imageName: String) -> UIImage? {
		return UIImage(named: imageName, in: Bundle(for: Self.self), compatibleWith: nil)
	}

	private func buttonText() -> String {
		return buttonTexts[textType] ?? buttonTexts[LoginButtonTextType.general] ?? ""
	}

	private func sendAnalyticsForEvent(_ eventType: AnalyticsEventType) {
		var eventData: SDKAnalyticsEventData
		switch eventType {
		case .sberIDLoginShow:
			eventData = SDKAnalyticsEventData.makeLoginShowEventData(buttonSettings: settings,
																		isButtonPersonalized: isPersonalized)
		case .sberIDLoginButtonClick:
			eventData = SDKAnalyticsEventData.makeLoginButtonClickEventData(buttonSettings: settings,
																			   isButtonPersonalized: isPersonalized)
		case .sberIDWrongButtonSize:
			eventData = SDKAnalyticsEventData.makeDataForWrongButtonSizeEvent(desiredWidth: settings.desiredWidth,
																  measuredWidth: settings.width)
		default:
			return
		}
		StaticStorage.analyticsService.sendEvent(eventType,
												 by: StaticStorage.analyticsService.eventTracker,
												 properties: eventData.paramsAsADictionary())
		print("""
			\n✅👁👁 Analytics prepared. \(eventType.rawValue).\n\
			Params: \(eventData.paramsAsADictionary())
			""")
	}
}

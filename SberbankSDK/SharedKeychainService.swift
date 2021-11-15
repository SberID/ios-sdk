//
//  KeychainService.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 09.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

/// Перечисление предусмотренных для хранения данных
enum DataToStore: String {

	/// Маскированное имя
	case maskedName
	/// Набор данных для персонализированной кнопки
	case personalizedButtonData
}

/// Протокол сервиса для работы с shared keychain
protocol SharedKeychainServiceProtocol {

	/// Сохранение Data в shared keychain для ключа-персонализированной-кнопки
	/// перезаписывает, если значение уже существует
	func savePersonalizedButtonData(_: Data)

	/// Получение маскированного имени из keychain
	func getPersonalizedButtonMaskedName() -> String?

	/// Удаление Data из shared keychain для ключа-персонализированной-кнопки
	func deletePersonalizedButtonData()
}

/// Сервис работы с shared keychain между приложениями одного издателя.
final class SharedKeychainService: NSObject, SharedKeychainServiceProtocol {

	let appIdKey = "AppIdentifierPrefix"
	let keychainGroupEnding = "ru.sberbank.onlineiphone.shared"
	private var appIdPrefix = String()
	private(set) var sharedKeychainGroup = String()
	private var baseQuery = [String: NSObject]()
	private var keychain: KeychainWrapperProtocol = KeychainWrapper()

	/// Инициализатор
	/// - Parameter keychainWrapper: класс реализующий взаимодействие с keychain
	init(keychainWrapper: KeychainWrapperProtocol = KeychainWrapper()) {
		keychain = keychainWrapper
		appIdPrefix = Bundle.main.object(forInfoDictionaryKey: appIdKey) as? String ?? ""
		sharedKeychainGroup = appIdPrefix + keychainGroupEnding
		baseQuery = [
			kSecClass.string: kSecClassGenericPassword,
			kSecAttrAccessGroup.string: sharedKeychainGroup as NSObject,
			kSecAttrAccessible.string: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
		]
	}

	func savePersonalizedButtonData(_ value: Data) {
		_ = saveValue(value, forKey: DataToStore.personalizedButtonData.rawValue)
	}

	func deletePersonalizedButtonData() {
		_ = deleteValueForKey(DataToStore.personalizedButtonData.rawValue)
	}

	func getPersonalizedButtonMaskedName() -> String? {
		var value: String?
		let jsonDecoder = JSONDecoder()

		if let retrievedData = getDataForKey(DataToStore.personalizedButtonData.rawValue) {
			value = try? jsonDecoder.decode(PersonalizedButtonData.self, from: retrievedData).maskedName
        }
		return value
	}

	// MARK: Private

	/// Cохранение Data в keychain. Если для указанного ключа уже есть значение, оно будет перезаписано.
	/// - Parameters:
	///   - value: сохраняемая Data
	///   - key: ключ, по которому сохраняем
	private func saveValue(_ value: Data, forKey key: String) -> Bool {
		var specificQueryPart: [String: NSObject] = [
			kSecAttrService.string: key as NSObject
		]
		var finalQuery = baseQuery.merging(specificQueryPart, uniquingKeysWith: { current, _ in current })
		_ = keychain.delete(finalQuery)

		specificQueryPart = [
			kSecValueData.string: value as NSObject,
			kSecAttrService.string: key as NSObject
		]
		finalQuery = baseQuery.merging(specificQueryPart, uniquingKeysWith: { current, _ in current })
		let status = keychain.save(finalQuery)
		return status == 0
	}

	/// Получение значения из keychain по ключу
	/// - Parameter key: ключ, по которому хранится значение
	private func getDataForKey(_ key: String) -> Data? {
		let specificQueryPart: [String: NSObject] = [
			kSecReturnData.string: true as NSObject,
			kSecAttrService.string: key as NSObject,
			kSecMatchLimit.string: kSecMatchLimitOne
		]
		let finalQuery = baseQuery.merging(specificQueryPart, uniquingKeysWith: { current, _ in current })
		let keychainResponse = keychain.get(finalQuery)
		let retrievedData = keychainResponse?.queryResult as? Data
		return retrievedData
	}

	/// Удаление значения для ключа
	/// - Parameter key: ключ, по которому удаляем
	private func deleteValueForKey(_ key: String) -> Bool {
		let specificQueryPart: [String: NSObject] = [
		  kSecAttrService.string: key as NSObject
		]
		let finalQuery = baseQuery.merging(specificQueryPart, uniquingKeysWith: { current, _ in current })
		let status = keychain.delete(finalQuery)
		return status == 0
	}
}

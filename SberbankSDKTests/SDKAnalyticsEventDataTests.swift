//
//  SDKAnalyticsEventDataTests.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 01.12.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
@testable import SberbankSDK

final class SDKAnalyticsEventDataTests: XCTestCase {

	func testCompositioningParamsAsADictionary() {
		// Arrange
		var exampleData = SDKAnalyticsEventData(eventType: .sberIDLoginShow)
		exampleData.colorView = "green"
		exampleData.heightView = "35.0"
		exampleData.widthView = "55.0"
		exampleData.measuredWidthView = "60.0"
		exampleData.personalView = "0"
		exampleData.result = "1"
		exampleData.errorDescription = "errorExample"

		// Act
		let result = exampleData.paramsAsADictionary()

		// Assert
		XCTAssert(result == [ "eventAction": "SberID Login Show",
							  "colorView": "green",
							  "heightView": "35.0",
							  "widthView": "55.0",
							  "measuredWidthView": "60.0",
							  "personalView": "0",
							  "result": "1",
							  "errorDescription": "errorExample"])
	}

	func testMakingDataForLoginShowEvent() {
		// Arrange
		var expectedResult = SDKAnalyticsEventData(eventType: .sberIDLoginShow)
		expectedResult.addSdkVersion()
		expectedResult.colorView = "green"
		expectedResult.heightView = "35.0"
		expectedResult.widthView = "55.0"
		expectedResult.personalView = "0"

		let buttonSettings = LoginButtonSettings(backgroundColor: .green, cornerRadius: 0, desiredWidth: 0, borderWidth: 0, borderColor: .red, titleColor: .white, logoName: "testLogoName", logoSize: CGSize.zero, fontSize: 16, height: 35, width: 55)

		// Act
		let result = SDKAnalyticsEventData.makeLoginShowEventData(buttonSettings: buttonSettings, isButtonPersonalized: false)

		// Assert
		XCTAssert(result == expectedResult)
    }

	func testMakingDataForLoginAuthResultEvent() {
		var expectedResult = SDKAnalyticsEventData(eventType: .sberIDLoginAuthResult)
		expectedResult.result = "0"
		expectedResult.errorDescription = SberbankSDKError.unknownError.errorDescription

        // Arrange
		let response = SBKAuthResponse(success: false, nonce: "nonce", state: "state", authCode: "AAA-aaa", error: SberbankSDKError.unknownError.errorDescription)

		// Act
		let result = SDKAnalyticsEventData.makeDataForLoginAuthResultEvent(result: response)

		// Assert
		XCTAssert(result == expectedResult)
    }

	func testMakingDataForWrongButtonSizeEvent() {
        // Arrange
		var expectedResult = SDKAnalyticsEventData(eventType: .sberIDWrongButtonSize)
		expectedResult.measuredWidthView = "30.0"
		expectedResult.widthView = "10.0"

		// Act
		let result = SDKAnalyticsEventData.makeDataForWrongButtonSizeEvent(desiredWidth: 10, measuredWidth: 30)

		// Assert
		XCTAssert(result == expectedResult)
    }

	func testMakingDataForLoginButtonClickEvent() {
        // Arrange
		var expectedResult = SDKAnalyticsEventData(eventType: .sberIDLoginButtonClick)
		expectedResult.colorView = "white"
		expectedResult.heightView = "35.0"
		expectedResult.widthView = "55.0"
		expectedResult.personalView = "1"

		let buttonSettings = LoginButtonSettings(backgroundColor: .white, cornerRadius: 0, desiredWidth: 0, borderWidth: 0, borderColor: .red, titleColor: .white, logoName: "testLogoName", logoSize: CGSize.zero, fontSize: 16, height: 35, width: 55)

		// Act
		let result = SDKAnalyticsEventData.makeLoginButtonClickEventData(buttonSettings: buttonSettings, isButtonPersonalized: true)

		// Assert
		XCTAssert(result == expectedResult)
    }
}

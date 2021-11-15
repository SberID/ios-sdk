//
//  SBKUtilsTests.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 16.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
@testable import SberbankSDK

final class SBKUtilsTests: XCTestCase {

	func testCreateVerifier() {
		// Arrange
		let bytes: [UInt8] = [116, 24, 223, 180, 151, 153, 224, 37,
							  79, 250, 96, 125, 216, 173, 187, 186,
							  22, 212, 37, 77, 105, 214, 191, 240,
							  91, 88, 5, 88, 83, 132, 141, 121]
		let data = Data(bytes: bytes, count: 32)
		let expectedResult = "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"

		// Act
		let result = SBKUtils.createVerifierForData(data)

		// Assert
		XCTAssertEqual(result, expectedResult)
	}

	func testCreateChallenge() {
		// Arrange
		let testVerivier = "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
		let expectedResult = "E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM"

		// Act
		let result = SBKUtils.createChallenge(testVerivier)

		// Assert
		XCTAssertEqual(result, expectedResult)
	}

	func testGetSSOUrlStringGetsCorrectParameterValueAndDecodeIt() {
		// Arrange
		let urlString = "www://host.ru?key=abc&sberIDRedirect=sberbankonline%3A%2F%2Fsberid.ru%3FqueryParam%3DkeyValue"
		let originalUrl = URL(string: urlString)

		// Act
		let result = SBKUtils.getSSOUrlStringFrom(originalUrl)

		// Assert
		XCTAssertEqual(result, "sberbankonline://sberid.ru")
	}

	func testGetSSOUrlStringGetsCorrectParameterValueIfItNotDecoded() {
		// Arrange
		let urlString = "www://host.ru?key=abc&sberIDRedirect=sberbankonline://sberid.ru"
		let originalUrl = URL(string: urlString)

		// Act
		let result = SBKUtils.getSSOUrlStringFrom(originalUrl)

		// Assert
		XCTAssertEqual(result, "sberbankonline://sberid.ru")
	}
}

//
//  AuthManagerTests.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 13.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
@testable import SberbankSDK

final class AuthManagerTests: XCTestCase {

	var urlOpennerSpy: URLOpennerMock!
	var analyticsServiceSpy: AnalyticsServiceSpy!
	var navigationControllerSpy: NavigationControllerSpy!

    override func setUp() {
		super.setUp()
		urlOpennerSpy = .init()
		analyticsServiceSpy = .init()
		navigationControllerSpy = .init()
		StaticStorage.analyticsService = analyticsServiceSpy
		SBKAuthManager.navigationController = navigationControllerSpy
    }

    override func tearDown() {
		navigationControllerSpy = nil
        urlOpennerSpy = nil
		super.tearDown()
    }

	func testGetResponseSuccess()
	{
		// Arrange
		let request = makeRequest()
		let urlString = "merchantApp://authRedirect?code=FA2154AC-3451-C01A-B2D3-C231DBB2E20F&state=" + request.state
		guard let url = URL(string: urlString) else { return }

		SBKAuthManager.auth(withSberId: request)

		let expectant = expectation(description: "Waiting for parse response")
		let completion: (SBKAuthResponse) -> Void = { response in
			// Assert
			XCTAssertEqual(response.nonce, request.nonce)
			XCTAssertEqual(response.authCode, "FA2154AC-3451-C01A-B2D3-C231DBB2E20F")
			XCTAssertNil(response.error)
			XCTAssert(response.isSuccess)
			expectant.fulfill()
		}

		// Act
		SBKAuthManager.getResponseFrom(url, completion: completion)
		waitForExpectations(timeout: 2)

		// Assert
		XCTAssertNil(StaticStorage.nonce)
		XCTAssertNil(StaticStorage.state)
	}

	func testGetResponseRetunsFailIfWrongStateInUrl() {

		// Arrange
		let urlString = "merchantApp://authRedirect?code=FA2154AC-3451-C01A-B2D3-C231DBB2E20F&state=other_state"
		guard let url = URL(string: urlString) else { return }
		let request = makeRequest()
		SBKAuthManager.auth(withSberId: request)

		let expectant = expectation(description: "Waiting for parse response")
		let completion: (SBKAuthResponse) -> Void = { response in
			// Assert
			XCTAssertEqual(response.nonce, request.nonce)
			XCTAssertEqual(response.authCode, "FA2154AC-3451-C01A-B2D3-C231DBB2E20F")
			XCTAssertEqual(response.error, "invalid_state")
			XCTAssertFalse(response.isSuccess)
			expectant.fulfill()
		}

		// Act
		SBKAuthManager.getResponseFrom(url, completion: completion)
		waitForExpectations(timeout: 2)

		// Assert
		XCTAssertNil(StaticStorage.nonce)
		XCTAssertNil(StaticStorage.state)
	}

	func testGetResponseFailedAuthCodeIsEmpty() {

		// Arrange
		let request = makeRequest()
		let urlString = "merchantApp://authRedirect?state=" + request.state
		guard let url = URL(string: urlString) else { return }

		SBKAuthManager.auth(withSberId: request)

		let expectant = expectation(description: "Waiting for parse response")
		let completion: (SBKAuthResponse) -> Void = { response in
			// Assert
			XCTAssertEqual(response.nonce, request.nonce)
			XCTAssertTrue(response.authCode?.isEmpty ?? true)
			XCTAssertEqual(response.error, "internal_error")
			XCTAssertFalse(response.isSuccess)
			expectant.fulfill()
		}

		// Act
		SBKAuthManager.getResponseFrom(url, completion: completion)
		waitForExpectations(timeout: 2)

		// Assert
		XCTAssertNil(StaticStorage.nonce)
		XCTAssertNil(StaticStorage.state)
	}

	// MARK: Helpers

	private func makeRequest() -> SBKAuthRequest {
		let request = SBKAuthRequest()
		request.clientId = "client_id"
		request.scope = "read write"
		request.state = "some_state"
		request.redirectUri = "merchantApp://authRedirect"
		request.nonce = "some_nonce"
		request.codeChallenge = "some_code_challenge"
		request.codeChallengeMethod = SBKAuthRequest.challengeMethod
		return request
	}
}

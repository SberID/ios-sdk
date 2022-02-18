//
//  AuthServiceTests.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 23.06.2021.
//  Copyright © 2021 Sberbank. All rights reserved.
//

import XCTest
import SafariServices
@testable import SberbankSDK

final class AuthServiceTests: XCTestCase {

	var authService: AuthService!
	var urlOpennerSpy: URLOpennerMock!
	var analyticsServiceSpy: AnalyticsServiceSpy!
	var navigationControllerSpy: NavigationControllerSpy!

	override func setUp() {
		super.setUp()
		urlOpennerSpy = .init()
		analyticsServiceSpy = .init()
		navigationControllerSpy = .init()
		StaticStorage.analyticsService = analyticsServiceSpy
		authService = AuthService(urlOpenner: urlOpennerSpy)
	}

	override func tearDown() {
		authService = nil
		urlOpennerSpy = nil
		navigationControllerSpy = nil
		super.tearDown()
	}

	func testStartAuthPresentSafariveViewControllerIfNoSbolApp() {
		//Arrange
		urlOpennerSpy.canOpenUrlResult = false

		// Act
		authService.startAuth(request: makeRequest(), navigationController: navigationControllerSpy)

		// Assert
		XCTAssertTrue(navigationControllerSpy.presentCalled, "SVC не был показан пользователю")
		XCTAssertNotNil(navigationControllerSpy.viewControllerToPresent as? SFSafariViewController)
	}

	func testStartAuthOpensSbolIfSbolAppExists() {
		// Arrange
		let url = URL(string:"""
					  sberbankidexternallogin://sberbankid?\
					  state=some_state&\
					  code_challenge_method=S256&\
					  code_challenge=some_code_challenge&\
					  scope=read%20write&\
					  redirect_uri=merchantApp://authRedirect&\
					  client_id=client_id&\
					  nonce=some_nonce
					  """)
		urlOpennerSpy.canOpenUrlResult = true

		// Act
		authService.startAuth(request: makeRequest(), navigationController: navigationControllerSpy)

		// Assert
		XCTAssertTrue(urlOpennerSpy.openURLCalled)
		XCTAssertNil(urlOpennerSpy.passedCompletion)
		XCTAssertTrue(urlOpennerSpy.passedOptions.isEmpty)
		XCTAssertTrue(urlOpennerSpy.passedUrlToOpen?.isSimilarTo(url: url) ?? false)
	}

	func testStartAuthReturnsURLwithoutCodeChallengeParamsIfAppExistsAndCodeChallengeNil()
	{
		// Arrange
		let url = URL(string:"""
					  sberbankidexternallogin://sberbankid?\
					  client_id=client_id&\
					  nonce=some_nonce&\
					  state=some_state&\
					  scope=read%20write&\
					  redirect_uri=merchantApp://authRedirect
					  """)
		let request = makeRequest()
		request.codeChallenge = nil
		request.codeChallengeMethod = nil
		urlOpennerSpy.canOpenUrlResult = true

		// Act
		authService.startAuth(request: request, navigationController: navigationControllerSpy)

		// Assert
		XCTAssertTrue(urlOpennerSpy.openURLCalled)
		XCTAssertNil(urlOpennerSpy.passedCompletion)
		XCTAssertTrue(urlOpennerSpy.passedOptions.isEmpty)
		XCTAssertTrue(urlOpennerSpy.passedUrlToOpen?.isSimilarTo(url: url) ?? false)
	}

	func testStartSoleLoginWebPageAuthShowSVC() {
		// Arrange
		urlOpennerSpy.canOpenUrlResult = true

		// Act
		let result = authService.startSoleLoginWebPageAuth(request: makeRequest(),
												  svcRedirectUrlString: "https://testAppRedirect.uri",
												  navigationController: navigationControllerSpy)

		// Assert
		XCTAssertTrue(result)
		XCTAssertTrue(navigationControllerSpy.presentCalled, "SVC не был показан пользователю")
		XCTAssertNotNil(navigationControllerSpy.viewControllerToPresent as? SFSafariViewController)
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

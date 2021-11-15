//
//  URLOpennerMock.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 16.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
@testable import SberbankSDK

final class URLOpennerMock: URLOpennerInput {

	var passedUrlToOpen: URL?
	var passedUrlToCanOpenMethod: URL?
	var passedUrlStringToCanOpenMethod: String?
	var passedOptions = [UIApplication.OpenExternalURLOptionsKey: Any]()
	var passedCompletion: ((Bool) -> Void)?
	
	var openURLCalled = false
	var canOpenAppCalled = false

	var  canOpenUrlResult = false


	func openURL(url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completion: ((Bool) -> Void)?) {
		openURLCalled = true
		passedUrlToOpen = url
		passedOptions = options
		passedCompletion = completion
	}

	func canOpenUrl(urlString: String) -> Bool {
		passedUrlStringToCanOpenMethod = urlString
		canOpenAppCalled = true
		return canOpenUrlResult
	}

	func canOpenUrl(_ url: URL) -> Bool {
		passedUrlToCanOpenMethod = url
		canOpenAppCalled = true
		return canOpenUrlResult
	}
}

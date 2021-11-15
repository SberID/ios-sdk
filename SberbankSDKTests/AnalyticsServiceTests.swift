//
//  AnalyticsServiceTests.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 01.12.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import XCTest
import MPAnalytics
import CoreLocation
@testable import SberbankSDK

final class AnalyticsServiceTests: XCTestCase {

    func testEendEventCallsEventTrackerWithCorrectParams() {
		// Arrange
		let analytics = AnalyticsService()
		let trackerMock = EventTrackerMock()
		let expectedProperties = [
			"key1": "value1",
			"key2": "value2"
		]
		// Act
		analytics.sendEvent(.sberIDLoginShow, by: trackerMock, properties: ["key1": "value1", "key2": "value2"])

		// Assert
		XCTAssertTrue(NSDictionary(dictionary: trackerMock.passedProperties).isEqual(to: expectedProperties))
		XCTAssertTrue(NSDictionary(dictionary: trackerMock.passedParams).isEqual(to: [:]))
		XCTAssertEqual(trackerMock.passedEventName, "SberID Login Show")
    }
}

final class EventTrackerMock: EventTracker {

	var sendEventWithDictionaryCalled = false
	var passedEventName: String = ""
	var passedParams: [String: String] = [:]
	var passedProperties: [String: String] = [:]

	func sendEvent(eventName: String,
				   params: [String : String]?,
				   properties: [String : String]?,
				   storable: Bool,
				   location: CLLocationCoordinate2D?,
				   completion: Completion?) {
		sendEventWithDictionaryCalled = true
		passedEventName = eventName
		passedParams = params ?? [:]
		passedProperties = properties ?? [:]
		completion?(nil)
	}

	func sendEvent(eventName: String,
				   params: [String : String]?,
				   properties: KeyValuePairs<String, String>,
				   storable: Bool,
				   location: CLLocationCoordinate2D?,
				   completion: Completion?) {}

	func sendEvent(eventName: String,
				   fullData: [String : Any]?,
				   storable: Bool,
				   location: CLLocationCoordinate2D?,
				   completion: Completion?) {}

	func sendEvent(urlSessionTaskResponse: URLResponse?, transportError: Error?, completion: Completion?) {}

	func sendEvent(sessionTaskMetrics: URLSessionTaskMetrics, completion: Completion?) {}
}

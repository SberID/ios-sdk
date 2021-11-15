//
//  AnalyticsServiceSpy.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 23.06.2021.
//  Copyright © 2021 Sberbank. All rights reserved.
//

import MPAnalytics
@testable import SberbankSDK

final class AnalyticsServiceSpy: AnalyticsServiceProtocol {
	var eventTracker: EventTracker = EventTrackerMock()

	func sendEvent(_ eventType: AnalyticsEventType, by tracker: EventTracker, properties: [String : String]) {}
}

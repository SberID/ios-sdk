//
//  NavigationControllerSpy.swift
//  SberbankSDKTests
//
//  Created by Roman Kuzin on 02.06.2021.
//  Copyright © 2021 Sberbank. All rights reserved.
//

import UIKit

final class NavigationControllerSpy: UINavigationController {

    var popViewControllerCalled = false
	var presentCalled = false
	var pushCalled = false
    var pushedController: UIViewController?
    var viewControllerToPresent: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedController = viewController
		pushCalled = true
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return nil
    }

	override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		self.viewControllerToPresent = viewControllerToPresent
		presentCalled = true
	}
}

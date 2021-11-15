//
//  UIImage+extension.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 10.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import UIKit

extension UIImage {

	func scaleToSize(size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage ?? self
	}
}

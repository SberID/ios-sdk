//
//  SberbankSDKError.swift
//  SberbankSDK
//
//  Created by Roman Kuzin on 30.11.2020.
//  Copyright © 2020 Sberbank. All rights reserved.
//

import Foundation

/// Ошибки создаваемые SberbankSDK
public enum SberbankSDKError: Error {
    case unknownError
}

extension SberbankSDKError: LocalizedError {
	
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString("\nUnkonwn error while sending sberlytics event", comment: "SberbankSDK error")
        }
    }
}

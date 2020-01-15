//
//  PhraseLogger.swift
//  PhraseSwift
//
//  Created by Onur Torna on 18.12.19.
//  Copyright © 2019 Onur Torna. All rights reserved.
//

import Foundation

internal final class PhraseLogger {
    
    /// Logs given message if logging is enabled in settings
    /// - Parameter message: Message to log
    internal static func log(_ message: String?) {
        guard PhraseConfig.shared.isLoggingEnabled else { return }
        debugPrint(message ?? "")
    }
}

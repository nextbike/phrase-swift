//
//  PhraseConfig.swift
//  PhraseSwift
//
//  Created by Onur Torna on 18.12.19.
//  Copyright © 2019 Onur Torna. All rights reserved.
//

import Foundation

public final class PhraseConfig {
    
    public static let shared = PhraseConfig()
    
    /// Prints debug errors when enabled
    internal var isLoggingEnabled: Bool = true
    
    /// Supported characters to use in keys
    internal var supportedKeyChars: [PhraseCharacterSet] = SupportedCharSet.allCases
    
    /// Special start character to use when defining a key
    internal var keyStartChar: Character = Constant.defaultKeyStartChar
    
    /// Special end character to use when defining a key
    internal var keyEndChar: Character = Constant.defaultKeyEndChar
    
    private init() {
        // Left blank intentionally.
    }
    
    /// Configures the whole Phrase library to define logging, and key rule specification
    /// - Parameter isLoggingEnabled: Enables/Disables logging
    /// - Parameter supportedKeyChars: Supported characters to use it in keys
    /// - Parameter keyStartChar: Special starting character of the keys
    /// - Parameter keyEndChar: Special end character of the keys
    public func configure(isLoggingEnabled: Bool = true,
                          supportedKeyChars: [PhraseCharacterSet] = SupportedCharSet.allCases,
                          keyStartChar: Character = Constant.defaultKeyStartChar,
                          keyEndChar: Character = Constant.defaultKeyEndChar) {
        self.isLoggingEnabled = isLoggingEnabled
        self.supportedKeyChars = supportedKeyChars
        self.keyStartChar = keyStartChar
        self.keyEndChar = keyEndChar
    }
}

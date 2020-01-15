//
//  CharValidation.swift
//  PhraseSwift
//
//  Created by Onur Torna on 18.12.19.
//  Copyright © 2019 Onur Torna. All rights reserved.
//

import Foundation

internal final class CharValidation {
    
    internal static func isCharValid(_ char: Character) -> Bool {
        let currentSupportedChars = PhraseConfig.shared.supportedKeyChars

        return currentSupportedChars.reduce(into: false) { (result, supportedChar) in
            let isCharValid = supportedChar.unicodeInterval.start <= char && supportedChar.unicodeInterval.end >= char
            result = result || isCharValid
        }
    }
}

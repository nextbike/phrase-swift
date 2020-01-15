//
//  SupportedChar.swift
//  PhraseSwift
//
//  Created by Onur Torna on 18.12.19.
//  Copyright © 2019 Onur Torna. All rights reserved.
//

import Foundation

// MARK: - PhraseCharacterSet

/// Character set definition to use it for defining key rules
public protocol PhraseCharacterSet {
    
    /// Unicode interval of the start and end characters in the set
    var unicodeInterval: (start: Character, end: Character) { get }
}

// MARK: - SupportedCharSet

/// Shows possible supported chars in keys
/// Can be used directly or new type that conforms to PhraseCharacterSet might be created
public enum SupportedCharSet: PhraseCharacterSet, CaseIterable {
    case lowercaseLetters
    case uppercaseLetters
    case space
    case underscore
    
    public var unicodeInterval: (start: Character, end: Character) {
        switch self {
        case .lowercaseLetters:
            return ("a", "z")
        case .uppercaseLetters:
            return ("A", "Z")
        case .space:
            return (" ", " ")
        case .underscore:
            return ("_", "_")
        }
    }
}

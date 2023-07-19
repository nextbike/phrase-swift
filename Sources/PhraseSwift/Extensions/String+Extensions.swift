//
//  String+Extensions.swift
//  Phrase_Swift
//
//  Created by Jan Meier on 09.12.19.
//
import Foundation

internal extension String {
    // charAt(at:) returns a character at an integer (zero-based) position.
    // example:
    // let str = "hello"
    // var second = str.charAt(at: 1)
    //  -> "e"
    func charAt(index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
}

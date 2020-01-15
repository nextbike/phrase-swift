//
//  NSMutableAttributedString+Extensions.swift
//  Phrase_Swift
//
//  Created by Jan Meier on 09.12.19.
//
import Foundation

internal extension NSMutableAttributedString {
    
    func replace(start: Int, end: Int, toReplaceWith: String?) {
        guard let toReplaceWith = toReplaceWith else { return }
        let range = NSMakeRange(start, end - start)
        self.deleteCharacters(in: range)
        let mutableString = NSAttributedString(string: toReplaceWith)
        self.insert(mutableString, at: start)
    }
}

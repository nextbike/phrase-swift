//
//  NSMutableAttributedString+Extensions.swift
//  Phrase_Swift
//
//  Created by Jan Meier on 09.12.19.
//

import UIKit

public final class Phrase {
    
    // the unmodified original pattern
    private var pattern: String
    
    // all keys parsed from the original pattern, without braces
    private var keys: Set<String> = []
    private var keysToValue = [String: String]()
    
    // cached result after replacing all keys with corresponding values
    private var formatted: String?
    
    // the constructor parses the original pattern into this doubly-linked list of tokens
    private var head: Token?
    
    // when parsing, this is the current char
    private var curChar: Character
    private var curCharIndex: Int = 0
    
    // indicates parsing is complete
    
    // TODO: make it int 1
    public static let EOF: Character = Character(UnicodeScalar(0))
    
    @discardableResult public func put(key: String, value: String) -> Phrase {
        guard keys.contains(key) else  {
            return self
        }
        
        keysToValue[key] = value
        
        // Invalidate the cached formatted text
        formatted = nil
        return self
    }
    
    public func  putOptional(key: String, value: String) -> Phrase {
        if keys.contains(key) {
            put(key: key, value: value)
        }
        return self
    }
    
    public func format() -> String {
        if formatted == nil {
            // TODO: perf?
            let keysOfTranslations = Set(keysToValue.map { $0.key })
            
            if !keysOfTranslations.isSuperset(of: keys) {
                let missingKeys = keys.subtracting(keysOfTranslations)
                PhraseLogger.log("PhraseSwift found some missing keys: " + missingKeys.joined(separator: ",") + " in localization: " + pattern)
            }
            
            // Copy the original pattern to preserve all spans, such as bold, italic, etc.
            let sb = NSMutableAttributedString(string: pattern)
            while let t = head?.next {
                t.expand(target: sb, data: keysToValue)
                head = head!.next
            }
            formatted = sb.string
            
        }
        return formatted!
        
    }
    
    public init(pattern: String) {
        curChar = (pattern.count > 0) ? pattern.charAt(index: 0) : Phrase.EOF
        
        self.pattern = pattern
        
        // A hand-coded lexer based on the idioms in "Building Recognizers By Hand".
        // http://www.antlr2.org/book/byhand.pdf.
        
        var prev: Token? = nil
        while let next = token(prev: prev) {
            // creates a doubly-linked list of tokens starting with head
            if head == nil { head = next }
            prev = next
        }
    }
    
    public static func localize(_ input: String, keyValues: [String:String]) -> String {
        let phrase = Phrase(pattern: input)
        for keyValue in keyValues {
            phrase.put(key: keyValue.key, value: keyValue.value)
        }
        return phrase.format()
    }
    
    // returns the next token from the input, or nil when finished parsing
    private func token(prev: Token?) -> Token? {
        if curChar == Phrase.EOF {
            return nil
        }
        
        if self.curChar == PhraseConfig.shared.keyStartChar {
            let nextChar = lookahead()
            if nextChar == PhraseConfig.shared.keyStartChar {
                return leftCurlyBracket(prev: prev)
            } else if CharValidation.isCharValid(nextChar) {
                return key(prev: prev)
            } else {
                PhraseLogger.log("PhraseSwift found unexpected key start in localization: " + pattern)
                return key(prev: prev)
            }
        }
        return text(prev: prev)
    }
    
    /// Parses a key starting and ending with defined special character, default is  "{some_key}".
    /// - Parameter prev: Previous token
    private func key(prev: Token?) -> KeyToken {
        // Store keys as normal Strings; we don't want keys to contain spans.
        var sb = ""
        
        /// consume the opening special char, default is "{"
        consume()
        
        while CharValidation.isCharValid(curChar) {
            sb.append(curChar)
            consume()
        }
        
        // consume the closing '}'
        if curChar != PhraseConfig.shared.keyEndChar {
            PhraseLogger.log("PhraseSwift found some unclosed keys in localization: " + pattern)
            return KeyToken(prev: nil, key: "")
        }
        consume()
        
        if sb.count == 0 {
            PhraseLogger.log("PhraseSwift found some empty keys in localization: " + pattern)
        }
        
        let key = sb
        
        keys.insert(key)
        return KeyToken(prev: prev, key: key)
        
    }
    
    /** Consumes and returns a token for a sequence of text. */
    private func  text(prev : Token?) -> TextToken {
        let startIndex = curCharIndex
        
        while (curChar != PhraseConfig.shared.keyStartChar && curChar != Phrase.EOF) {
            consume()
        }
        return TextToken(prev: prev, textLength: curCharIndex - startIndex)
    }
    
    /** Consumes and returns a token representing two consecutive curly brackets. */
    private func leftCurlyBracket(prev: Token?) -> LeftCurlyBracketToken {
        consume()
        consume()
        return LeftCurlyBracketToken(prev: prev)
    }
    
    /** Returns the next character in the input pattern without advancing. */
    private func lookahead() -> Character {
        var result : Character = Phrase.EOF
        if curCharIndex < pattern.count - 1 {
            result = pattern.charAt(index: curCharIndex + 1)
        }
        return result
    }
    
    /**
     * Advances the current character position without any error checking. Consuming beyond the
     * end of the string can only happen if this parser contains a bug.
     */
    private func consume() {
        curCharIndex += 1
        if curCharIndex == pattern.count {
            curChar = Phrase.EOF
        } else {
            curChar = pattern.charAt(index: curCharIndex)
        }
    }
    
    // make abstract
    private class Token {
        private final var prev: Token?
        var next : Token?
        
        init(prev: Token?) {
            self.prev = prev
            if prev != nil {
                prev!.next = self
            }
        }
        
        /** Replace text in {@code target} with this token's associated value. */
        func expand(target: NSMutableAttributedString, data : [String: String]) {
            fatalError("PhraseSwift found errors: " + #function + " needs to be overridden")
        }
        
        /** Returns the number of characters after expansion. */
        func  getFormattedLength() -> Int {
            fatalError("PhraseSwift found errors: " + #function + " needs to be overridden")
        }
        
        /** Returns the character index after expansion. */
        func getFormattedStart() -> Int {
            guard let prev = prev else { return 0 }
            return prev.getFormattedStart() + prev.getFormattedLength()
        }
    }
    
    /** Ordinary text between token(s. */
    private class TextToken : Token {
        private var textLength : Int
        
        init(prev: Token?,  textLength: Int) {
            self.textLength = textLength
            super.init(prev: prev)
        }
        
        override func expand( target : NSMutableAttributedString, data : [String: String]) {
            // Don't alter spans in the target.
        }
        
        override func getFormattedLength() -> Int {
            return textLength
        }
    }
    
    /** A sequence of two curly brackets. */
    private class LeftCurlyBracketToken : Token {
        override init(prev: Token?) {
            super.init(prev: prev)
        }
        
        override func expand(target: NSMutableAttributedString ,data:  [String: String] ) {
            let start = getFormattedStart()
            target.replace(start: start, end: start + 2, toReplaceWith: "\(PhraseConfig.shared.keyStartChar)")
        }
        
        override func getFormattedLength() -> Int {
            // Replace {{ with {.
            return 1
        }
    }
    
    private  class KeyToken : Token {
        /** The key without { and }. */
        private var key : String
        private var value : String?
        
        init( prev: Token?, key: String) {
            self.key = key
            super.init(prev: prev)
        }
        
        override func expand( target: NSMutableAttributedString,  data: [String: String]) {
            value = data[key]
            let replaceFrom = getFormattedStart()
            
            // Add 2 to account for the opening and closing brackets.
            let replaceTo = replaceFrom + key.count + 2
            
            target.replace(start: replaceFrom, end: replaceTo, toReplaceWith: value)
        }
        
        override func getFormattedLength() -> Int {
            // Note that value is only present after expand. Don't error check because this is all
            // private code.
            guard let value = value else { return 0 }
            return value.count
        }
    }
}

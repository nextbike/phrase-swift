//
//  PhraseSwiftTests.swift
//  PhraseSwiftTests
//
//  Created by Onur Torna on 17.12.19.
//  Copyright © 2019 Onur Torna. All rights reserved.
//

import XCTest
@testable import PhraseSwift

class PhraseSwiftTests: XCTestCase {

    override func setUp() {
        // Sets to default values
        let supportedKeyChars: [SupportedCharSet] = [.lowercaseLetters, .uppercaseLetters, .space, .underscore]
        PhraseConfig.shared.configure(supportedKeyChars: supportedKeyChars,
                                      keyStartChar: "{",
                                      keyEndChar: "}")
    }

    func testOneKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hello, my name is {name}")
            .put(key: "name", value: "Onur")
            .format()
        XCTAssert(firstOutput == "Hello, my name is Onur")
        
        let secondOutput = Phrase(pattern: "Greetings, welcome {guest}, you are here!")
            .put(key: "guest", value: "Onur")
            .format()
        XCTAssert(secondOutput == "Greetings, welcome Onur, you are here!")
    }
    
    func testMultipleKeys() {
        let firstOutput = Phrase(pattern: "Hi, this is a {keyOne} test with {keyTwo} keys.")
            .put(key: "keyOne", value: "first")
            .put(key: "keyTwo", value: "multiple")
            .format()
        XCTAssert(firstOutput == "Hi, this is a first test with multiple keys.")
        
        let secondOutput = Phrase(pattern: "Hi, {first} {second} {third} {fourth}")
            .put(key: "first", value: "Hope")
            .put(key: "second", value: "you")
            .put(key: "third", value: "enjoy")
            .put(key: "fourth", value: "it")
            .format()
        XCTAssert(secondOutput == "Hi, Hope you enjoy it")
    }
    
    func testTwoKeysOnly() {
        let output = Phrase.localize(
            "{first} {second}",
            keyValues: ["first": "Hello", "second": "world"]
        )
        XCTAssertEqual(output, "Hello world")
    }
    
    func testBidirectionalKeyValueLocalization() {
        let firstOutput = Phrase(pattern: "Hi, this is a {key_one} test with {key_two} keys.")
            .put(key: "key_two", value: "multiple")
            .put(key: "key_one", value: "bidirectional")
            .format()
        XCTAssert(firstOutput == "Hi, this is a bidirectional test with multiple keys.")
        
        let secondOutput = Phrase(pattern: "Hi, {first} {second} {third} {fourth}")
            .put(key: "fourth", value: "it")
            .put(key: "third", value: "enjoy")
            .put(key: "first", value: "Hope")
            .put(key: "second", value: "you")
            .format()
        XCTAssert(secondOutput == "Hi, Hope you enjoy it")
    }
    
    func testNoKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hi, this is a no key test with multiple keys.")
            .put(key: "keyone", value: "there is no key")
            .format()
        XCTAssert(firstOutput == "Hi, this is a no key test with multiple keys.")
        
        let secondOutput = Phrase(pattern: "Hi, Hope you enjoy it")
            .put(key: "first", value: "first")
            .put(key: "second", value: "second")
            .put(key: "third", value: "third")
            .put(key: "fourth", value: "fourth")
            .format()
        XCTAssert(secondOutput == "Hi, Hope you enjoy it")
    }
    
    func testMissingKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hi, there should be a {key}.")
            .format()
        XCTAssert(firstOutput == "Hi, there should be a {key}.")
        
        let secondOutput = Phrase(pattern: "Hi, {first} you {second} it")
            .put(key: "first", value: "Hope")
            .format()
        XCTAssert(secondOutput == "Hi, Hope you {second} it")
    }
    
    func testStartsWithKeyLocalization() {
        let firstOutput = Phrase(pattern: "{key} is awesome!")
            .put(key: "key", value: "PhraseSwift")
            .format()
        XCTAssert(firstOutput == "PhraseSwift is awesome!")
        
        let secondOutput = Phrase(pattern: "{one} is better than {two}.")
            .put(key: "one", value: "Two")
            .put(key: "two", value: "one")
            .format()
        XCTAssert(secondOutput == "Two is better than one.")
    }
    
    func testEndsWithKeyLocalization() {
        let firstOutput = Phrase(pattern: "PhraseSwift is {stupid}")
            .put(key: "stupid", value: "awesome")
            .format()
        XCTAssert(firstOutput == "PhraseSwift is awesome")
        
        let secondOutput = Phrase(pattern: "{one} is better than {two}")
            .put(key: "one", value: "Two")
            .put(key: "two", value: "one")
            .format()
        XCTAssert(secondOutput == "Two is better than one")
    }
    
    func testSpacedKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hi, this is a {key one} test with {key two} keys.")
            .put(key: "key two", value: "multiple")
            .put(key: "key one", value: "spaced key")
            .format()
        XCTAssert(firstOutput == "Hi, this is a spaced key test with multiple keys.")
        
        let secondOutput = Phrase(pattern: "Hello, my full name is {name surname} nice to meet you")
            .put(key: "name surname", value: "Onur Torna")
            .format()
        XCTAssert(secondOutput == "Hello, my full name is Onur Torna nice to meet you")
    }
    
    func testUnclosedKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hi, this is a {key one test with one key.")
            .put(key: "key one", value: "unclosed key")
            .format()
        XCTAssert(firstOutput == "Hi, this is a {key one test with one key.")
        
        let secondOutput = Phrase(pattern: "Hello, my full name is name surname} nice to meet you")
            .put(key: "name surname", value: "Onur Torna")
            .format()
        XCTAssert(secondOutput == "Hello, my full name is name surname} nice to meet you")
    }
    
    func testEmptyKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hi, this is a {} empty key test with one key.")
            .put(key: "key one", value: "unclosed key")
            .format()
        XCTAssert(firstOutput == "Hi, this is a {} empty key test with one key.")
    }
    
    func testUppercasedKeyLocalization() {
        let firstOutput = Phrase(pattern: "Hi, this is a {UPPERCASED_KEY} test with one key.")
            .put(key: "UPPERCASED_KEY", value: "Uppercased Key")
            .format()
        XCTAssert(firstOutput == "Hi, this is a Uppercased Key test with one key.")
    }
    
    func testStringContainingEmojis() {
        let firstOutput = Phrase(pattern: "Hi, this is a {normal key} test with one 🐥.")
            .put(key: "normal key", value: "Normal Key")
            .format()
        XCTAssert(firstOutput == "Hi, this is a Normal Key test with one 🐥.")
    }
    
    func testStartEndKeyCharConfigurationChange() {
        let supportedKeyChars: [SupportedCharSet] = [.lowercaseLetters, .uppercaseLetters, .space, .underscore]
        PhraseConfig.shared.configure(supportedKeyChars: supportedKeyChars,
                                      keyStartChar: "|",
                                      keyEndChar: "|")
        let firstOutput = Phrase(pattern: "Hi, this is a |changed start char key| test with |param| parameter.")
            .put(key: "changed start char key", value: "Changed Start Char Key")
            .put(key: "param", value: "two")
            .format()
        XCTAssert(firstOutput == "Hi, this is a Changed Start Char Key test with two parameter.")
    }
    
    func testSupportedCharConfigurationChange() {
        PhraseConfig.shared.configure(supportedKeyChars: [SupportedCharSet.lowercaseLetters],
                                      keyStartChar: "{",
                                      keyEndChar: "}")
        let firstOutput = Phrase(pattern: "Hi, this is a {param} test with one parameter.")
            .put(key: "param", value: "Supported Char Change")
            .format()
        XCTAssert(firstOutput == "Hi, this is a Supported Char Change test with one parameter.")
        
        let secondOutput = Phrase(pattern: "Hi, this test needs to {RESULT}. It has {UPPERCASE} keys")
            .put(key: "RESULT", value: "fail")
            .put(key: "UPPERCASE", value: "uppercase")
            .format()
        XCTAssertFalse(secondOutput == "Hi, this test needs to fail. It has uppercase keys")
        
        let thirdOutput = Phrase(pattern: "Hi, this test needs to {result}. It has {space space} keys")
            .put(key: "result", value: "fail")
            .put(key: "space space", value: "space")
            .format()
        XCTAssert(thirdOutput == "Hi, this test needs to fail. It has {space space} keys")
    }
    
    func testHelperLocalizationFunction() {
        
        let firstOutput = Phrase.localize("Hi, this is a {Key one} test with {Key two} keys.",
                                          keyValues: ["Key two": "multiple",
                                                      "Key one": "spaced key"])
        XCTAssert(firstOutput == "Hi, this is a spaced key test with multiple keys.")
        
        let secondOutput = Phrase.localize("Hi, this is a {key_one} test with {key_two} keys.",
                                           keyValues: ["key_two": "multiple",
                                                       "key_one": "bidirectional"])
        XCTAssert(secondOutput == "Hi, this is a bidirectional test with multiple keys.")
    }
    
    func testUserGreeting() {       
        
        XCTAssertEqual(Phrase.localize(
            "👋 Hey {username} !",
            keyValues: ["username": "Rider"]
        ), "👋 Hey Rider !")
        
        XCTAssertEqual(Phrase.localize(
            "Hey {username}! 👋",
            keyValues: ["username": "Rider"]
        ), "Hey Rider! 👋")
        
        XCTAssertEqual(Phrase.localize(
            "Hey {username} 👋!",
            keyValues: ["username": "Rider"]
        ), "Hey Rider 👋!")
    }
}

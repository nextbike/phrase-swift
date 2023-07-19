# PhraseSwift

**Description**:  Use curly bracket placeholders within strings [just like on Android](https://github.com/square/phrase). We created this in order to use the same translation phrases for both our Android and iOS apps.

This is a lightweight port of [Phrase - Android string formatting](https://github.com/square/phrase) into Swift 5 and used in production for our iOS customer app. It has no other dependencies and can be installed using CocoaPods.

## Features

- Replace placeholders with curly brackets within strings with corresponding content (`Hello, my name is {name}` becomes `"Hello, my name is Ada"`)
- Supports multiple placeholders per string
- When using [Phrase](https://github.com/square/phrase) for Android and [PhraseSwift](https://github.com/nextbike/phrase-swift) for iOS, you can use the same translation sources for both platforms
- Licence: [Apache 2.0](https://github.com/nextbike/phrase-swift/blob/master/LICENSE)

## Installation

### Swift Package Manager (SPM)

_This is the recommended way to install and use this library._
 
 
#### Within an Xcode Project

1. In Project Settings, on the tab "Package Dependencies", click "+" and add `github.com/nextbike/phrase-swift`
2. You're done.


#### `Package.swift`-Based SPM Project

1. Add a dependency in Package.swift:
    ```swift
    dependencies: [
        .package(url: "https://github.com/nextbike/phrase-swift", from: "1.0.0")
    ]
    ```
2. For each relevant target, add a dependency
    ```swift
    .target(
        name: "Example",
        dependencies: [
            .product(name: "PhraseSwift", package: "phrase-swift"),
        ]
    )
    ```
3. You're done.

Also check out [Editing a package dependency as a local package](https://developer.apple.com/documentation/xcode/editing-a-package-dependency-as-a-local-package) to work in local changes within your existing project that uses this package.

### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website.

```
pod 'PhraseSwift', :git => 'https://github.com/nextbike/phrase-swift.git', '~> 1.0.0
```

## Usage


```swift
import PhraseSwift

let source = "Hello {world}"
let output = Phrase.localize(source, keyValues: ["world": "nextbike"])

// output: "Hello nextbike"
```

## How to test

Includes a suite of unit tests to cover frequent cases of placeholder location and handling within strings. Run `swift test` or open up the Swift Package within Xcode.

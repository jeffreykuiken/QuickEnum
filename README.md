# QuickEnum

QuickEnum is a Swift Macro that can quickly generate a simple enum declaration, based on the type of the property that the macro is attached to and a set of cases that you provide.

For example:

```swift
@Enum("view", "edit", "new") var mode: DisplayMode = .view

// The code above will expand into:
var mode: DisplayMode = .view

enum DisplayMode {
    case view, edit, new
}
```

## Use case

You may find yourself often defining simple enums like the one above, for properties that only have a few predefined options, and that you're using for one specific property.

You could either declare the enum right above or below the property, but that quickly leads to messy code. Alternatively, you define the enum in a completely different place, but now when you want to check the possible cases of the enum you've got to navigate to a different context.

With the @Enum macro, you can create this enum on the same line as the property itself, without taking up any additional lines of code.

## Options & Usage

The `@Enum` macro takes any number of strings as its parameters. Each string will be converted to a case of the enum. There are no further options and settings.

### Free bonus: `#enum`

QuickEnum also provides a `#enum` macro. This macro is not attached to a property, but can be placed anywhere<sup>*</sup>. Because the name of the enum cannot be inferred, you have to provide it yourself:

```swift
#enum("DisplayMode", cases: "view", "edit", "new")

// The code above will expand into:
enum DisplayMode { case view, edit, new }
```

Unfortunately the macro cannot be used in the global scope. This is a limitation by the Swift's macro system.

## Installation

Use Swift Package Manager to add the QuickEnum package to your project.

```swift
.package(url: "https://github.com/jeffreykuiken/QuickEnum", from: "1.0.0")
```

Then just `import QuickEnum` at the top of your file and you can use the macros.

## Disclaimer

This is the very first macro that I've ever created. It's covered by unit tests, and it does what it should do. But macros are hard, so there may be ways to break the macro in unforeseen ways. Use at your own risk. If you run into any issue, please let me know by opening an issue or creating a PR.

## License

This project is released under the BSD Zero Clause License. Use it however you like, no attribution needed.

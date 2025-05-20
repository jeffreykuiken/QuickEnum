// The Swift Programming Language
// https://docs.swift.org/swift-book

/// This macro generates an enum based on the declared type of a variable, and the provided cases.
///
/// For example,
/// ```
/// @Enum("edit", "view") var mode: Mode
/// ```
///
/// produces the following enum:
/// ```
/// enum Mode {
///     case edit, view
/// }
/// ```
@attached(peer, names: arbitrary)
public macro Enum(_ cases: String...) = #externalMacro(module: "QuickEnumMacros", type: "QuickEnumMacro")


/// This macro generates an enum based on the provided name and cases. For example,
///
/// ```
/// #Enum("Mode", cases: "edit", "view")
/// ```
///
/// produces the following enum:
/// ```
/// enum Mode {
///     case edit, view
/// }
/// ````
@freestanding(declaration, names: arbitrary)
public macro Enum(_ name: String, cases: String...) = #externalMacro(module: "QuickEnumMacros", type: "QuickEnumMacro")

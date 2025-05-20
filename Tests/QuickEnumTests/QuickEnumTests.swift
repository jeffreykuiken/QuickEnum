import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(QuickEnumMacros)
import QuickEnumMacros

let testMacros: [String: Macro.Type] = [
    "Enum": QuickEnumMacro.self,
]
#endif

final class QuickEnumTests: XCTestCase {
    func testAttachedMacro() throws {
        #if canImport(QuickEnumMacros)
        assertMacroExpansion(
            """
            @Enum("one", "two", "three") var property: GeneratedEnum
            """,
            expandedSource: """
            var property: GeneratedEnum
            
            /// GeneratedEnum is a generated enum with the following cases: one, two, three
            enum GeneratedEnum {
                case one
                case two
                case three
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testEmptyCaseList() throws {
        #if canImport(QuickEnumMacros)
        assertMacroExpansion(
            """
            @Enum() var property: GeneratedEnum
            """,
            expandedSource: """
            var property: GeneratedEnum
            
            /// GeneratedEnum is a generated enum with the following cases: 
            enum GeneratedEnum {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "You have not specified any cases for the generated enum", line: 1, column: 1, severity: .warning)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testEmptyCaseListWithoutParenthesis() throws {
        #if canImport(QuickEnumMacros)
        assertMacroExpansion(
            """
            @Enum var property: GeneratedEnum
            """,
            expandedSource: """
            var property: GeneratedEnum
            
            /// GeneratedEnum is a generated enum with the following cases: 
            enum GeneratedEnum {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "You have not specified any cases for the generated enum", line: 1, column: 1, severity: .warning)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

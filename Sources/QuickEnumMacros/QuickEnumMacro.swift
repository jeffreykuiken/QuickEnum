import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

/// Implementation of the `Enum` macros.
public struct QuickEnumMacro: PeerMacro, DeclarationMacro {
    /// Implementation of the '@Enum' attached macro. It infers the enum name based on the type of
    /// the variable it's attached to.
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Get the property, which we need to infer the enum name
        guard let property = declaration.as(VariableDeclSyntax.self) else {
            context.diagnose(node: node, message: .requiresVariableDeclaration)
            return []
        }
        
        // Get the type identifier
        guard let typeAnnotation = property.bindings.first?.typeAnnotation,
              let type = typeAnnotation.type.as(IdentifierTypeSyntax.self)
        else {
            context.diagnose(node: node, message: .couldNotInferEnumName)
            return []
        }
        
        // Extract the enum name from the type, and clean it up (because it could contain leading
        // and trailing whitespaces
        let enumName = type.name.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse the provided cases
        let caseNames = node.arguments?.as(LabeledExprListSyntax.self)?.compactMap {
            $0.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)
        } ?? []
        
        // Check if the the cases were provided. If not, we will still generate the user, but
        // because this is most likely a user error, we show a warning.
        if caseNames.isEmpty {
            context.diagnose(node: node, message: .noCasesProvidedWarning)
        }
        
        // Generate the enum syntax, including a short docstring to list the cases
        guard let declaration = Self.GenerateEnumDeclSyntax(name: enumName, cases: caseNames) else {
            context.diagnose(node: node, message: .syntaxGenerationFailed)
            return []
        }
        
        return [DeclSyntax(declaration)]
    }
    
    
    /// Implementation of the '#enum' freestanding macro. The name of the enum is explicitly
    /// provided.
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Parse the provided enum name, and clean it up (because it could contain leading
        // and trailing whitespaces
        guard let nameAttributeSyntax = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let nameSyntax = nameAttributeSyntax.segments.first?.as(StringSegmentSyntax.self) else {
            context.diagnose(node: node, message: .couldNotParseEnumName)
            return []
        }
        
        let enumName = nameSyntax.content.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Verify that the provided name is not an empty string
        guard !enumName.isEmpty else {
            context.diagnose(node: node, message: .emptyNameNotAllowed)
            return []
        }
        
        // Parse the provided cases
        let caseNames = node.arguments.dropFirst().compactMap {
            $0.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)
        }
        
        // Check if the the cases were provided. If not, we will still generate the user, but
        // because this is most likely a user error, we show a warning.
        if caseNames.isEmpty {
            context.diagnose(node: node, message: .noCasesProvidedWarning)
        }
        
        // Generate the enum syntax, including a short docstring to list the cases
        guard let declaration = Self.GenerateEnumDeclSyntax(name: enumName, cases: caseNames) else {
            context.diagnose(node: node, message: .syntaxGenerationFailed)
            return []
        }
        
        return [DeclSyntax(declaration)]
    }
    
    
    /// Utility function to generate an enum declaration syntax based on the name of an enum and a
    /// list of cases
    private static func GenerateEnumDeclSyntax(name: String, cases: [StringSegmentSyntax]) -> EnumDeclSyntax? {
        do {
            let caseList = cases.map({ $0.description }).joined(separator: ", ")
            
            let decl = try EnumDeclSyntax("""
            /// \(raw: name) is a generated enum with the following cases: \(raw: caseList)
            enum \(raw: name)
            """) {
                for caseName in cases {
                    try EnumCaseDeclSyntax("case \(caseName)")
                }
            }
            
            return decl
        } catch {
            // Unable to generate syntax. Return nil, so the macro implementation can throw an error
            // diagnosis
            return nil
        }
    }
}

// Convenience extension to quickly diagnose a QuickEnumMacroDiagnostic
fileprivate extension MacroExpansionContext {
    func diagnose(node: some SyntaxProtocol, message: QuickEnumMacroDiagnostic) {
        let diagnostic = Diagnostic(node: node, message: message)
        self.diagnose(diagnostic)
    }
}

@main
struct QuickEnumPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        QuickEnumMacro.self,
    ]
}

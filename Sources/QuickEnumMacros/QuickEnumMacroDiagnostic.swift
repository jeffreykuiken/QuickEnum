//
//  QuickEnumMacroDiagnostic.swift
//  QuickEnum
//
//  Created by Jeffrey on 20/05/2025.
//

import SwiftDiagnostics

enum QuickEnumMacroDiagnostic: String, DiagnosticMessage {
    case requiresVariableDeclaration,
         couldNotInferEnumName,
         couldNotParseEnumName,
         emptyNameNotAllowed,
         syntaxGenerationFailed,
         noCasesProvidedWarning
    
    var message: String {
        switch self {
            case .requiresVariableDeclaration:
                return "The Enum macro can only be applied to a variable declaration"
            case .couldNotInferEnumName:
                return "The Enum macro was unable to infer the enum name based on the type annotation"
            case .couldNotParseEnumName:
                return "The Enum macro was unable to parse the provided enum name"
            case .emptyNameNotAllowed:
                return "Empty enum names are not allowed"
            case .syntaxGenerationFailed:
                return "The Enum macro was unable to generate the enum definiton syntax"
            case .noCasesProvidedWarning:
                return "You have not specified any cases for the generated enum"
        }
    }
    
    var severity: DiagnosticSeverity {
        switch self {
            case .noCasesProvidedWarning: return .warning
            default: return .error
        }
    }
    
    var diagnosticID: MessageID {
        return MessageID(domain: "QuickEnumMacros", id: self.rawValue)
    }
}

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
         syntaxGenerationFailed,
         noCasesProvidedWarning
    
    var message: String {
        switch self {
            case .requiresVariableDeclaration:
                return "@Enum can only be applied to a variable declaration"
            case .couldNotInferEnumName:
                return "@Enum was unable to infer the enum name based on the type annotation"
            case .syntaxGenerationFailed:
                return "@Enum was unable to generate the enum definiton syntax"
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

import Foundation

enum TextEncodingError: LocalizedError {
    case nestingNotSupported([CodingKey])
    case keysRequired
    
    var errorDescription: String? {
        switch self {
        case let .nestingNotSupported(path):
            return "Could not encode at path \(path) because LogfmtEncoder does not support nesting"
        case .keysRequired:
            return "Could not encode single value because LogfmtEncoder requires top-level keys"
        }
    }
}

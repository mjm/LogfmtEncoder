import Foundation

public class LogfmtEncoder {
    public init() {}
    
    public func encode<T: Encodable>(_ value: T) throws -> String {
        let encoder = _LogfmtEncoder()
        
        try value.encode(to: encoder)
        
        return encoder.encodedString
    }
}

class _LogfmtEncoder: Encoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var storage = FieldStorage()
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = LogfmtKeyedEncodingContainer<Key>(encoder: self, storage: storage, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("LogfmtEncoder does not support unkeyed encoding")
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
    
    var encodedString: String {
        var fieldStrings = [String]()
        
        for (key, value) in storage.fields {
            fieldStrings.append("\(key)=\(value.quotedIfNeeded())")
        }
        
        return fieldStrings.joined(separator: " ")
    }
}

private let dateFormatter = ISO8601DateFormatter()
private let floatFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 4
    formatter.minimumFractionDigits = 0
    formatter.minimumIntegerDigits = 1
    return formatter
}()

extension _LogfmtEncoder {
    func stringify(_ value: Bool) -> String { return value ? "true" : "false" }
    func stringify(_ value: String) -> String { return value }
    func stringify(_ value: Double) -> String { return floatFormatter.string(from: value as NSNumber) ?? String(describing: value) }
    func stringify(_ value: Float) -> String { return floatFormatter.string(from: value as NSNumber) ?? String(describing: value) }
    func stringify(_ value: Int) -> String { return String(describing: value) }
    func stringify(_ value: Int8) -> String { return String(describing: value) }
    func stringify(_ value: Int16) -> String { return String(describing: value) }
    func stringify(_ value: Int32) -> String { return String(describing: value) }
    func stringify(_ value: Int64) -> String { return String(describing: value) }
    func stringify(_ value: UInt) -> String { return String(describing: value) }
    func stringify(_ value: UInt8) -> String { return String(describing: value) }
    func stringify(_ value: UInt16) -> String { return String(describing: value) }
    func stringify(_ value: UInt32) -> String { return String(describing: value) }
    func stringify(_ value: UInt64) -> String { return String(describing: value) }
    
    func stringify<T: Encodable>(_ value: T, codingPath: [CodingKey]) throws -> String? {
        if T.self == Date.self || T.self == NSDate.self {
            return dateFormatter.string(from: value as! Date)
        }
        
        if T.self == URL.self || T.self == NSURL.self {
            return (value as! URL).absoluteString
        }
        
        var oldCodingPath = self.codingPath
        self.codingPath = codingPath
        defer { self.codingPath = oldCodingPath }
        
        try value.encode(to: self)
        return nil
    }
}

class FieldStorage {
    var fields: [(key: String, value: String)] = []
    
    func append(_ key: String, _ value: String) {
        fields.append((key, value))
    }
}

private let quoteRequiringCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._/@^+").inverted

extension String {
    fileprivate func quotedIfNeeded() -> String {
        let needsQuoted = unicodeScalars.contains { quoteRequiringCharacters.contains($0) }
        if needsQuoted {
            return String(reflecting: self)
        } else {
            return self
        }
    }
}

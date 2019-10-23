import Foundation

struct LogfmtKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
    typealias Key = K
    
    var encoder: _LogfmtEncoder
    var storage: FieldStorage
    var codingPath: [CodingKey]
    
    mutating func encodeNil(forKey key: K) throws {
    }
    
    mutating func encode(_ value: Bool, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: String, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Double, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Float, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Int, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Int8, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Int16, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Int32, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: Int64, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: UInt, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: UInt8, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: UInt16, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: UInt32, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode(_ value: UInt64, forKey key: K) throws {
        storage.append(makeKey(key), encoder.stringify(value))
    }
    
    mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
        if let str = try encoder.stringify(value, codingPath: codingPath + [key]) {
            storage.append(makeKey(key), str)
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        codingPath.append(key)
        defer { codingPath.removeLast() }
        
        let container = LogfmtKeyedEncodingContainer<NestedKey>(encoder: encoder, storage: storage, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        fatalError("LogfmtEncoder does not support unkeyed encoding")
    }
    
    mutating func superEncoder() -> Encoder {
        return encoder
    }
    
    mutating func superEncoder(forKey key: K) -> Encoder {
        return encoder
    }
    
    private func makeKey(_ key: K) -> String {
        (codingPath + [key]).map { $0.stringValue }.joined(separator: ".")
    }
}

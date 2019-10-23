extension _LogfmtEncoder: SingleValueEncodingContainer {
    func encodeNil() throws {
    }
    
    func encode(_ value: Bool) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: String) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Double) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Float) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Int) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Int8) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Int16) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Int32) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: Int64) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: UInt) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: UInt8) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: UInt16) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: UInt32) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode(_ value: UInt64) throws {
        try assertCanEncodeValue()
        storage.append(key, stringify(value))
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        try assertCanEncodeValue()
        
        if let str = try stringify(value, codingPath: codingPath) {
            storage.append(key, str)
        }
    }
    
    var key: String {
        codingPath.map { $0.stringValue }.joined(separator: ".")
    }
    
    private func assertCanEncodeValue() throws {
        if codingPath.count == 0 {
            throw TextEncodingError.keysRequired
        }
    }
}

import XCTest
import LogfmtEncoder

final class LogfmtEncoderTests: XCTestCase {
    struct TestStruct1: Encodable {
        var str: String
        var int: Int
        var double: Double
        var bool: Bool
        var url: URL
        var date: Date
    }
    
    let encoder = LogfmtEncoder()
    
    func testFlatStruct() throws {
        let value = TestStruct1(str: "a string value", int: 123, double: 4.567890, bool: false, url: URL(string: "https://www.google.com/")!, date: Date(timeIntervalSinceReferenceDate: 0))
        let text = try encoder.encode(value)
        XCTAssertEqual("str=\"a string value\" int=123 double=4.5679 bool=false url=\"https://www.google.com/\" date=\"2001-01-01T00:00:00Z\"", text)
    }
    
    struct TestStruct2: Encodable {
        var topValue: String
        var wrapped1: WrappedValue<Int>
        var wrapped2: WrappedValue<String>
    }
    
    struct WrappedValue<T: Encodable>: Encodable {
        var value: T
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    
    func testNestingSingleValues() throws {
        let value = TestStruct2(topValue: "abcdefg", wrapped1: WrappedValue(value: 839), wrapped2: WrappedValue(value: "this is a string"))
        let text = try encoder.encode(value)
        XCTAssertEqual("topValue=abcdefg wrapped1=839 wrapped2=\"this is a string\"", text)
    }
    
    struct TestStructOuter: Encodable {
        var topValue: String
        var nestedValue: TestStructInner
        
        enum CodingKeys: String, CodingKey {
            case topValue = "top_value"
            case nestedValue = "nested"
        }
    }
    
    struct TestStructInner: Encodable {
        var foo: String
        var bar: Int
        var wrapped: WrappedValue<String>
    }
    
    func testNestedKeys() throws {
        let value = TestStructOuter(topValue: "the top value", nestedValue: TestStructInner(foo: "a nested string", bar: 678, wrapped: WrappedValue(value: "wrapped")))
        let text = try encoder.encode(value)
        XCTAssertEqual("top_value=\"the top value\" nested.foo=\"a nested string\" nested.bar=678 nested.wrapped=wrapped", text)
    }
    
    struct TestStructNested: Encodable {
        var topValue: String
        var foo: String
        var bar: Int
        var wrapped: WrappedValue<String>
        
        enum CodingKeys: String, CodingKey {
            case topValue = "top"
            case nested = "nested"
        }
        
        enum InnerCodingKeys: String, CodingKey {
            case foo
            case bar
            case wrapped
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(topValue, forKey: .topValue)
            
            var nested = container.nestedContainer(keyedBy: InnerCodingKeys.self, forKey: .nested)
            try nested.encode(foo, forKey: .foo)
            try nested.encode(bar, forKey: .bar)
            try nested.encode(wrapped, forKey: .wrapped)
        }
    }
    
    func testInlineNestedKeys() throws {
        let value = TestStructNested(topValue: "the top value", foo: "a nested string", bar: 678, wrapped: WrappedValue(value: "wrapped"))
        let text = try encoder.encode(value)
        XCTAssertEqual("top=\"the top value\" nested.foo=\"a nested string\" nested.bar=678 nested.wrapped=wrapped", text)
    }

    static var allTests = [
        ("testFlatStruct", testFlatStruct),
        ("testNestingSingleValues", testNestingSingleValues),
        ("testNestedKeys", testNestedKeys),
        ("testInlineNestedKeys", testInlineNestedKeys),
    ]
}

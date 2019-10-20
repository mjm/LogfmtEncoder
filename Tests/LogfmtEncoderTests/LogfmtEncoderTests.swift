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

    static var allTests = [
        ("testFlatStruct", testFlatStruct),
        ("testNestingSingleValues", testNestingSingleValues),
    ]
}

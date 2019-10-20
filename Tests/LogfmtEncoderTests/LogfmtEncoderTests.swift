import XCTest
@testable import LogfmtEncoder

final class LogfmtEncoderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LogfmtEncoder().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

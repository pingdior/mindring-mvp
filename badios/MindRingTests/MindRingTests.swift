import XCTest
@testable import MindRing

final class MindRingTests: XCTestCase {
  func testMockDataSeed() {
    let seed = MockData.seed()
    XCTAssertFalse(seed.sessions.isEmpty)
    XCTAssertFalse(seed.captures.isEmpty)
  }
}

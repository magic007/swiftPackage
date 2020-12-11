import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BmobSwift2Tests.allTests),
    ]
}
#endif

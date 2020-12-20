import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(SymbolicTests.allTests),
        ]
    }
#endif

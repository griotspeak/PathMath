//
//  CGRect2DGridTests.swift
//  PathMath
//
//  Created by TJ Usiyan on 2016/31/10.
//  Copyright © 2016 Buttons and Lights LLC. All rights reserved.
//

#if os(OSX)
    import AppKit
#endif

#if os(iOS)
    import UIKit
#endif
import XCTest
@testable import PathMath

class CGRect2DGridTests: XCTestCase {
    func testIndices() {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let grid = try! CGRect2DGrid(size: rect.size, columns: 2, rows: 2)
        let result = Set(grid.indices)
        let expected: Set<CGRect2DGrid.CoordinatePair> = [
            CGRect2DGrid.CoordinatePair(column: 0, row: 0),
            CGRect2DGrid.CoordinatePair(column: 1, row: 0),
            CGRect2DGrid.CoordinatePair(column: 0, row: 1),
            CGRect2DGrid.CoordinatePair(column: 1, row: 1),
        ]
        XCTAssertEqual(result, expected)
    }
}

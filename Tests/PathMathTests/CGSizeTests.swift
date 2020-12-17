//
//  CGSizeTests.swift
//  PathMath
//
//  Created by TJ Usiyan on 19/10/26.
//  Copyright © 2019 Buttons and Lights LLC. All rights reserved.
//

#if os(OSX)
    import AppKit
#endif

#if os(iOS)
    import UIKit
#endif
import XCTest

class CGSizeTests: XCTestCase {
    func testRelativeCenter() {
        let outer = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        let inner = CGSize(width: 10, height: 10)

        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .zero), CGRect(x: 0, y: 0, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .init(x: 1.0, y: 1.0)), CGRect(x: 90, y: 90, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .init(x: 0.5, y: 0.5)), CGRect(x: 45, y: 45, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .init(x: 0.25, y: 0.25)), CGRect(x: 22.5, y: 22.5, width: 10, height: 10))

        let outerWith3040Shift: CGRect = {
            var back = outer
            back.origin.x += 30
            back.origin.y += 40
            return back
        }()

        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .zero), CGRect(x: 30, y: 40, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .init(x: 1.0, y: 1.0)), CGRect(x: 120, y: 130, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .init(x: 0.5, y: 0.5)), CGRect(x: 75, y: 85, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .init(x: 0.25, y: 0.25)), CGRect(x: 52.5, y: 62.5, width: 10, height: 10))
    }

    func testRelativeCenterWithInvertedY() {
        let outer = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        let inner = CGSize(width: 10, height: 10)

        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .zero, invertY: true), CGRect(x: 0, y: 90, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .init(x: 1.0, y: 1.0), invertY: true), CGRect(x: 90, y: 0, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .init(x: 0.5, y: 0.5), invertY: true), CGRect(x: 45, y: 45, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outer, relativeCenter: .init(x: 0.25, y: 0.25), invertY: true), CGRect(x: 22.5, y: 67.5, width: 10, height: 10))

        let outerWith3040Shift: CGRect = {
            var back = outer
            back.origin.x += 30
            back.origin.y += 40
            return back
        }()

        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .zero, invertY: true), CGRect(x: 30, y: 130, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .init(x: 1.0, y: 1.0), invertY: true), CGRect(x: 120, y: 40, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .init(x: 0.5, y: 0.5), invertY: true), CGRect(x: 75, y: 85, width: 10, height: 10))
        XCTAssertEqual(inner.positionedWithin(outerWith3040Shift, relativeCenter: .init(x: 0.25, y: 0.25), invertY: true), CGRect(x: 52.5, y: 107.5, width: 10, height: 10))
    }
}



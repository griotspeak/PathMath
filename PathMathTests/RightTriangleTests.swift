//
//  RightTriangleTests.swift
//  PathMath
//
//  Created by TJ Usiyan on 2017/06/04.
//  Copyright © 2017 Buttons and Lights LLC. All rights reserved.
//

import XCTest
import PathMath

private let __accuracy: Angle.Value = 0.000_000_000_000_01

class RightTriangleTests: XCTestCase {
    func testOneOneRootTwoWithOppositeAndAdjacent() {
        let instance = RightTriangle(lengthA: 1, lengthB: 1)
        XCTAssertEqual(instance.lengthC, sqrt(2))

        XCTAssertEqualWithAccuracy(instance.angleA.inDegrees, 45, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inDegrees, 45, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inDegrees, 90, accuracy: __accuracy)

        XCTAssertEqualWithAccuracy(instance.angleA.inRadians, .pi / 4, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inRadians, .pi / 4, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inRadians, .pi / 2, accuracy: __accuracy)
    }

    func testThreeFourFiveWithAngleAndAdjacent() {
        let instance = RightTriangle(lengthA: 3, lengthB: 4)
        XCTAssertEqual(instance.lengthC, 5)

        XCTAssertEqualWithAccuracy(instance.angleA.inDegrees, Angle.radians(asin(3 / 5)).inDegrees, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inDegrees, Angle.radians(asin(4 / 5)).inDegrees, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inDegrees, Angle.degrees(90).inDegrees,          accuracy: __accuracy)

        XCTAssertEqualWithAccuracy(instance.angleA.inRadians, asin(3 / 5),  accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inRadians, asin(4 / 5),  accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inRadians, .pi / 2,      accuracy: __accuracy)
    }

    func testThirtySixtyNinetyWithAngleAndOpposite() {
        let instance = RightTriangle(angleA: .degrees(30), lengthA: 1)
        XCTAssertEqualWithAccuracy(instance.lengthC, 2, accuracy: __accuracy)

        XCTAssertEqualWithAccuracy(instance.angleA.inDegrees, 30, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inDegrees, 60, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inDegrees, 90, accuracy: __accuracy)

        XCTAssertEqualWithAccuracy(instance.angleA.inRadians, .pi / 6, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inRadians, .pi / 3, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inRadians, .pi / 2, accuracy: __accuracy)
    }

    func testOneOneRootTwoWithAngleAndAdjacent() {
        let instance = RightTriangle(angleA: .degrees(45), lengthB: 1)
        XCTAssertEqualWithAccuracy(instance.lengthC, sqrt(2), accuracy: __accuracy)

        XCTAssertEqualWithAccuracy(instance.angleA.inDegrees, 45, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inDegrees, 45, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inDegrees, 90, accuracy: __accuracy)

        XCTAssertEqualWithAccuracy(instance.angleA.inRadians, .pi / 4, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleB.inRadians, .pi / 4, accuracy: __accuracy)
        XCTAssertEqualWithAccuracy(instance.angleC.inRadians, .pi / 2, accuracy: __accuracy)
    }
}

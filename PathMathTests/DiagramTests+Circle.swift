//
//  DiagramTests+Circle.swift
//  PathMath
//
//  Created by TJ Usiyan on 2017/05/31.
//  Copyright © 2017 Buttons and Lights LLC. All rights reserved.
//

#if os(OSX)
    import AppKit
#endif

#if os(iOS)
    import UIKit
#endif
import XCTest

import PathMath

extension DiagramTests {
    func testBoundsOfUnitCircleAtOrigin() {
        let unitCircle: Diagram = .circle(radius: 1, center: .zero)
        let result = unitCircle.bounds()
        let expected = CGRect(center: .zero, size: CGSize(width: 2, height: 2))
        XCTAssertEqual(result, expected)
    }

    func testBoundsOfUnitCircleAtOneOne() {
        let unitCircle: Diagram = .circle(radius: 1, center: CGPoint(x: 1, y: 1))
        let result = unitCircle.bounds()
        let expected = CGRect(center: CGPoint(x: 1, y: 1), size: CGSize(width: 2, height: 2))
        XCTAssertEqual(result, expected)
    }
    
    func testCogStuff() {
        let theCog = CogIcon<UIBezierPath>(holeRadius: 20,
                                           bodyRadius: 45,
                                           spokeHeight: 9,
                                           toothCount: 6,
                                           rotation: Angle(degrees: 180))
        
        enum Foo {
            case First(Bool)
            case Second(Bool)
        }
        
        var (theView, theLayer): (PlatformBaseLayerBackedView, CAShapeLayer) = theCog.createView(CGRect(x: 0, y: 0, width: 150, height: 150))
   print(theView)
    }
}

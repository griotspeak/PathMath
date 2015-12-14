//
//  BezierPath.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/25/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

#if os(OSX)
    import AppKit
#endif

#if os(iOS)
    import UIKit
#endif


import QuartzCore

public enum LineJoinStyle {
    case Miter
    case Round
    case Bevel

    public var cgLineJoin:CGLineJoin {
        switch self {
        case .Miter:
            return .Miter
        case .Round:
            return .Round
        case .Bevel:
            return .Bevel
        }
    }

    public init(cgLineJoin:CGLineJoin) {
        switch cgLineJoin {
        case .Miter:
            self = .Miter
        case .Round:
            self = .Round
        case .Bevel:
            self = .Bevel
        }
    }

    #if os(OSX)
    public init(nsLineJoin:NSLineJoinStyle) {
        /* @todo add `==` to CGLineJoin 2015-05-24 */
        switch nsLineJoin {
        case .MiterLineJoinStyle:
            self = .Miter
        case .RoundLineJoinStyle:
            self = .Round
        case .BevelLineJoinStyle:
            self = .Bevel
        }
    }

    public var nsLineJoin:NSLineJoinStyle {
        switch self {
        case .Miter:
            return NSLineJoinStyle.MiterLineJoinStyle
        case .Round:
            return NSLineJoinStyle.RoundLineJoinStyle
        case .Bevel:
            return NSLineJoinStyle.BevelLineJoinStyle
        }
    }
    #endif
}

public protocol BezierPathType {
    var quartzPath: CGPathRef? { get }

    init()

    var usesEvenOddFillRule:Bool { get set }
    var bezierLineJoinStyle:LineJoinStyle { get set }

    // Path construction
    mutating func moveToPoint(point: CGPoint)

    mutating func addLineToPoint(point: CGPoint)
    mutating func addArcWithCenter(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)

    mutating func closePath()
    static func scrubClockwiseValue(value:Bool) -> Bool
}

#if os(iOS)
    extension UIBezierPath : BezierPathType {
        public var quartzPath: CGPathRef? {
            return self.CGPath
        }

        public var bezierLineJoinStyle:LineJoinStyle {
            get {
                return LineJoinStyle(cgLineJoin: lineJoinStyle)
            } set(value) {
                self.lineJoinStyle = value.cgLineJoin
            }
        }

        public static func scrubClockwiseValue(value: Bool) -> Bool {
            return value
        }
    }
#endif

#if os(OSX)
    extension NSBezierPath : BezierPathType {
        public var usesEvenOddFillRule:Bool {
            get {
                return windingRule == NSWindingRule.EvenOddWindingRule
            }
            set(value) {
                windingRule = value ? NSWindingRule.EvenOddWindingRule : NSWindingRule.NonZeroWindingRule
            }
        }
        public var bezierLineJoinStyle:LineJoinStyle {
            get {
                return LineJoinStyle(nsLineJoin: lineJoinStyle)
            } set(value) {
                self.lineJoinStyle = value.nsLineJoin
            }
        }

        public func addLineToPoint(point: NSPoint) {
            lineToPoint(point)
        }

        public func addArcWithCenter(center: NSPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            appendBezierPathWithArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }

        public static func scrubClockwiseValue(value: Bool) -> Bool {
            return !value
        }
    }

    extension NSBezierPath /* [QuartzUtilities](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Paths/Paths.html#//apple_ref/doc/uid/TP40003290-CH206-SW2) */ {
        public var quartzPath: CGPathRef? {
            let numElements = elementCount
            guard numElements > 0 else { return nil }

            var pointArray = UnsafeMutablePointer<NSPoint>.alloc(3)
            let arrayPointer = UnsafeBufferPointer<NSPoint>(start: pointArray, count: 3)
            defer { pointArray.dealloc(3) }

            var didClosePath:Bool = true
            let immutablePath: CGPathRef?
            let mutablePath = CGPathCreateMutable()

            for i in 0..<numElements {
                switch elementAtIndex(i, associatedPoints:pointArray) {
                case .MoveToBezierPathElement:
                    if !didClosePath {
                        CGPathCloseSubpath(mutablePath)
                        didClosePath = true
                    }
                    CGPathMoveToPoint(mutablePath, nil, arrayPointer[0].x, arrayPointer[0].y)
                case .LineToBezierPathElement:
                    CGPathAddLineToPoint(mutablePath, nil, arrayPointer[0].x, arrayPointer[0].y)
                    didClosePath = false
                case .CurveToBezierPathElement:
                                    CGPathAddCurveToPoint(mutablePath, nil, arrayPointer[0].x, arrayPointer[0].y,
                                        arrayPointer[1].x, arrayPointer[1].y,
                                        arrayPointer[2].x, arrayPointer[2].y)
                                    didClosePath = false
                case .ClosePathBezierPathElement:
                    CGPathCloseSubpath(mutablePath)
                    didClosePath = true
                }

            }
            if !didClosePath {
                CGPathCloseSubpath(mutablePath)
            }

            immutablePath = CGPathCreateCopy(mutablePath)
            return immutablePath
        }
    }


#endif
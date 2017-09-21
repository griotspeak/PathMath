//
//  BezierPath.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/25/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

#if os(OSX)
    import AppKit
    public typealias PlatformBezierPath = NSBezierPath
#endif

#if os(iOS)
    import UIKit
    public typealias PlatformBezierPath = UIBezierPath
#endif


import QuartzCore

public enum LineJoinStyle {
    case miter
    case round
    case bevel

    public var cgLineJoin:CGLineJoin {
        switch self {
        case .miter:
            return .miter
        case .round:
            return .round
        case .bevel:
            return .bevel
        }
    }

    public init(cgLineJoin:CGLineJoin) {
        switch cgLineJoin {
        case .miter:
            self = .miter
        case .round:
            self = .round
        case .bevel:
            self = .bevel
        }
    }

    #if os(OSX)
    public init(nsLineJoin:NSBezierPath.LineJoinStyle) {
        /* @todo add `==` to CGLineJoin 2015-05-24 */
        switch nsLineJoin {
        case .miterLineJoinStyle:
            self = .miter
        case .roundLineJoinStyle:
            self = .round
        case .bevelLineJoinStyle:
            self = .bevel
        }
    }

    public var nsLineJoin:NSBezierPath.LineJoinStyle {
        switch self {
        case .miter:
            return NSBezierPath.LineJoinStyle.miterLineJoinStyle
        case .round:
            return NSBezierPath.LineJoinStyle.roundLineJoinStyle
        case .bevel:
            return NSBezierPath.LineJoinStyle.bevelLineJoinStyle
        }
    }
    #endif
}

public protocol BezierPathType /* TODO: `class`? since none of these return anything, I am obviously assuming side effects (mutability).  2015-12-22 */ {
    var quartzPath: CGPath? { get }

    init()

    var usesEvenOddWindingRule: Bool { get set }
    var bezierLineJoinStyle: LineJoinStyle { get set }

    // Path construction
    mutating func move(to point: CGPoint)

    mutating func addLine(to point: CGPoint)
    mutating func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)

    mutating func addCircle(withCenter center: CGPoint, radius: CGFloat, clockwise: Bool)

    mutating func close()
    static var shouldNegateClockwiseValue: Bool { get }
    mutating func removeAllPoints()
}

extension BezierPathType {
    public static func platformClockwiseValue(fromActualClockwiseValue value:Bool) -> Bool {
        if shouldNegateClockwiseValue {
            return !value
        } else {
            return value
        }
    }

    mutating public func move(toX x: CGFloat, y: CGFloat) {
        move(to: CGPoint(x: x, y: y))
    }

    mutating public func addLine(toX x: CGFloat, y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }

    mutating public func addCircle(withCenter center: CGPoint, radius: CGFloat, clockwise: Bool = Self.platformClockwiseValue(fromActualClockwiseValue: true)) {
        let start = Angle(degrees:0)

        move(to: start.pointInCircle(center, radius: radius))
        addArc(withCenter: center,
               radius: radius,
               startAngle: Angle(degrees:0).apiValue,
               endAngle: Angle(degrees:360).apiValue,
               clockwise: clockwise)
    }
}
extension BezierPathType {

    mutating public func add(_ rect: CGRect, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) {
        let corners = rect.corners(originLocation)

        move(to: corners.topLeft)
        addLine(to: corners.topRight)
        addLine(to: corners.bottomRight)
        addLine(to: corners.bottomLeft)
        close()

    }

    mutating public func add(_ rect: CGRect, cornerRadius: CGFloat, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) {
        let innerRect = rect.insetBy(dx: cornerRadius, dy: cornerRadius)
        let inner = innerRect.edgeDescription(originLocation)
        let innerCorners = innerRect.corners(originLocation)
        let outer = rect.edgeDescription(originLocation)

        move(toX: inner.left, y: outer.top)
        addLine(toX: inner.right, y: outer.top)
        addArc(withCenter: innerCorners.topRight, radius: cornerRadius, startAngle: Angle(degrees: 270).apiValue, endAngle: Angle(degrees: 360).apiValue, clockwise: true)

        addLine(toX: outer.right, y: inner.top)
        addLine(toX: outer.right, y: inner.bottom)
        addArc(withCenter: innerCorners.bottomRight, radius: cornerRadius, startAngle: Angle(degrees: 0).apiValue, endAngle: Angle(degrees: 90).apiValue, clockwise: true)

        addLine(toX: inner.right, y: outer.bottom)
        addLine(toX: inner.left, y: outer.bottom)
        addArc(withCenter: innerCorners.bottomLeft, radius: cornerRadius, startAngle: Angle(degrees: 90).apiValue, endAngle: Angle(degrees: 180).apiValue, clockwise: true)

        addLine(toX: outer.left, y: inner.bottom)
        addLine(toX: outer.left, y: inner.top)
        addArc(withCenter: innerCorners.topLeft, radius: cornerRadius, startAngle: Angle(degrees: 180).apiValue, endAngle: Angle(degrees: 270).apiValue, clockwise: true)

        close()
    }
}


#if os(iOS)
    extension UIBezierPath : BezierPathType {
        public var usesEvenOddWindingRule: Bool {
            get {
                return self.usesEvenOddFillRule
            }
            set {
                self.usesEvenOddFillRule = newValue
            }
        }

        public var quartzPath: CGPath? {
            return self.cgPath
        }

        public var bezierLineJoinStyle:LineJoinStyle {
            get {
                return LineJoinStyle(cgLineJoin: lineJoinStyle)
            } set(value) {
                self.lineJoinStyle = value.cgLineJoin
            }
        }

        public static var shouldNegateClockwiseValue: Bool {
            return false
        }
    }
#endif

#if os(OSX)
    extension NSBezierPath : BezierPathType {
        public func addLine(to point: CGPoint) {
            addLineToPoint(point)
        }

        public var usesEvenOddWindingRule:Bool {
            get {
                return windingRule == NSBezierPath.WindingRule.evenOddWindingRule
            }
            set(value) {
                windingRule = value ? NSBezierPath.WindingRule.evenOddWindingRule : NSBezierPath.WindingRule.nonZeroWindingRule
            }
        }
        public var bezierLineJoinStyle: PathMath.LineJoinStyle {
            get {
                return PathMath.LineJoinStyle(nsLineJoin: lineJoinStyle)
            } set(value) {
                self.lineJoinStyle = value.nsLineJoin
            }
        }

        public func addLineToPoint(_ point: NSPoint) {
            line(to: point)
        }

        public func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }

        public static var shouldNegateClockwiseValue: Bool {
            return true
        }
    }

    extension NSBezierPath /* [QuartzUtilities](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Paths/Paths.html#//apple_ref/doc/uid/TP40003290-CH206-SW2) */ {
        public var quartzPath: CGPath? {
            let numElements = elementCount
            guard numElements > 0 else { return nil }

            var pointArray = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
            defer { pointArray.deallocate(capacity: 3) }
            let arrayPointer = UnsafeBufferPointer<NSPoint>(start: pointArray, count: 3)

            var didClosePath:Bool = true
            let immutablePath: CGPath?
            let mutablePath = CGMutablePath()

            for i in 0..<numElements {
                switch element(at: i, associatedPoints:pointArray) {
                case .moveToBezierPathElement:
                    if !didClosePath {
                        mutablePath.closeSubpath()
                        didClosePath = true
                    }
                    mutablePath.move(to: arrayPointer[0])
                case .lineToBezierPathElement:
                    mutablePath.addLine(to: arrayPointer[0])
                    didClosePath = false
                case .curveToBezierPathElement:
                    mutablePath.addCurve(to: arrayPointer[2], control1: arrayPointer[0], control2: arrayPointer[1])
                    didClosePath = false
                case .closePathBezierPathElement:
                    mutablePath.closeSubpath()
                    didClosePath = true
                }

            }
            if !didClosePath {
                mutablePath.closeSubpath()
            }
            
            immutablePath = mutablePath.copy()
            return immutablePath
        }
    }
    
    
#endif

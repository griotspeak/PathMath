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
            return CGLineJoin.Miter
        case .Round:
            return CGLineJoin.Round
        case .Bevel:
            return CGLineJoin.Bevel
        }
    }

    public init?(cgLineJoin:CGLineJoin) {
        /* @todo add `==` to CGLineJoin 2015-05-24 */
        if cgLineJoin.rawValue == CGLineJoin.Miter.rawValue {
            self = .Miter
        } else if cgLineJoin.rawValue == CGLineJoin.Round.rawValue {
            self = .Round
        } else if cgLineJoin.rawValue == CGLineJoin.Bevel.rawValue {
            self = .Bevel
        } else {
            return nil
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
    //    var CGPath: CGPath

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
    public var bezierLineJoinStyle:LineJoinStyle {
        get {
            return LineJoinStyle(cgLineJoin: lineJoinStyle)!
        }
        set(value) {
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
#endif

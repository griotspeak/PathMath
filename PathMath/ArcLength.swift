//
//  ArcLength.swift
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

public enum ArcLength {
    case degrees(CGFloat)
    case radians(CGFloat)

    public var inDegrees:CGFloat {
        switch self {
        case let .degrees(value):
            return value
        case let .radians(value):
            return radiansToDegrees(value)
        }
    }

    public var inRadians:CGFloat {
        switch self {
        case let .degrees(value):
            return degreesToRadians(value)
        case let .radians(value):
            return value
        }
    }

    public init(degrees value:CGFloat) {
        self = .degrees(value)
    }

    public init(radians value:CGFloat) {
        self = .radians(value)
    }

    private func divide(_ divisor: CGFloat) -> ArcLength {
        switch self {
        case let .degrees(value):
            return ArcLength(degrees: value / divisor)
        case let .radians(value):
            return ArcLength(radians: value / divisor)
        }
    }

    private func degreesToRadians(_ degrees:CGFloat) -> CGFloat {
        return degrees * (CGFloat(M_PI) / 180.0)
    }

    private func radiansToDegrees(_ radians:CGFloat) -> CGFloat {
        return radians * (180.0 / CGFloat(M_PI))
    }

    #if os(OSX)
    public var apiValue:CGFloat {
        return inDegrees
    }
    #endif

    #if os(iOS)
    public var apiValue:CGFloat {
        return inRadians
    }
    #endif
}

extension ArcLength {
    public func pointInCircle(_ center:CGPoint, radius:CGFloat) -> CGPoint {
        let angleInRadians:CGFloat = inRadians
        return CGPoint(x: center.x + (radius * cos(angleInRadians)), y: center.y + (radius * sin(angleInRadians)))
    }
}

internal func +(first:ArcLength, second:ArcLength) -> ArcLength {
    switch first {
    case let .degrees(value):
        return ArcLength(degrees: value + second.inDegrees)
    case let .radians(value):
        return ArcLength(radians: value + second.inRadians)
    }
}

internal func -(first:ArcLength, second:ArcLength) -> ArcLength {
    switch first {
    case let .degrees(value):
        return ArcLength(degrees: value - second.inDegrees)
    case let .radians(value):
        return ArcLength(radians: value - second.inRadians)
    }
}

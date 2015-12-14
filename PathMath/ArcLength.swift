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
    case Degrees(CGFloat)
    case Radians(CGFloat)

    public var inDegrees:CGFloat {
        switch self {
        case let .Degrees(value):
            return value
        case let .Radians(value):
            return radiansToDegrees(value)
        }
    }

    public var inRadians:CGFloat {
        switch self {
        case let .Degrees(value):
            return degreesToRadians(value)
        case let .Radians(value):
            return value
        }
    }

    public init(degrees value:CGFloat) {
        self = .Degrees(value)
    }

    public init(radians value:CGFloat) {
        self = .Radians(value)
    }

    private func divide(divisor: CGFloat) -> ArcLength {
        switch self {
        case let .Degrees(value):
            return ArcLength(degrees: value / divisor)
        case let .Radians(value):
            return ArcLength(radians: value / divisor)
        }
    }

    private func degreesToRadians(degrees:CGFloat) -> CGFloat {
        return degrees * (CGFloat(M_PI) / 180.0)
    }

    private func radiansToDegrees(radians:CGFloat) -> CGFloat {
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

internal func +(first:ArcLength, second:ArcLength) -> ArcLength {
    switch first {
    case let .Degrees(value):
        return ArcLength(degrees: value + second.inDegrees)
    case let .Radians(value):
        return ArcLength(radians: value + second.inRadians)
    }
}

internal func -(first:ArcLength, second:ArcLength) -> ArcLength {
    switch first {
    case let .Degrees(value):
        return ArcLength(degrees: value - second.inDegrees)
    case let .Radians(value):
        return ArcLength(radians: value - second.inRadians)
    }
}

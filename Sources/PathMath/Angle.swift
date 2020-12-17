//
//  Angle.swift
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

public enum Angle {
    /* TODO: Convert to type parameter 2017-06-02 */
    public typealias Value = CGFloat
    case degrees(Value)
    case radians(Value)

    public var inDegrees:Value {
        switch self {
        case let .degrees(value):
            return value
        case let .radians(value):
            return radiansToDegrees(value)
        }
    }

    /* TODO: return Angle 2017-06-04 */
    /* TODO: __sinPi 2017-06-08 */
    public var inRadians:Value {
        switch self {
        case let .degrees(value):
            return degreesToRadians(value)
        case let .radians(value):
            return value
        }
    }

    public init(degrees value:Value) {
        self = .degrees(value)
    }

    public init(radians value:Value) {
        self = .radians(value)
    }

    private func divide(_ divisor: Value) -> Angle {
        switch self {
        case let .degrees(value):
            return Angle(degrees: value / divisor)
        case let .radians(value):
            return Angle(radians: value / divisor)
        }
    }

    private func degreesToRadians(_ degrees:Value) -> Value {
        return degrees * (.pi / 180.0)
    }

    private func radiansToDegrees(_ radians:Value) -> Value {
        return radians * (180.0 / .pi)
    }

    #if os(OSX)
    public var apiValue:Value {
        return inDegrees
    }
    #endif

    #if os(iOS)
    public var apiValue:Value {
        return inRadians
    }
    #endif
}

extension Angle {
    public func pointInCircle(_ center:CGPoint, radius:Value) -> CGPoint {
        let angleInRadians:Value = inRadians
        return CGPoint(x: center.x + (radius * cos(angleInRadians)), y: center.y + (radius * sin(angleInRadians)))
    }
}

internal func +(first:Angle, second:Angle) -> Angle {
    switch first {
    case let .degrees(value):
        return Angle(degrees: value + second.inDegrees)
    case let .radians(value):
        return Angle(radians: value + second.inRadians)
    }
}

internal func -(first:Angle, second:Angle) -> Angle {
    switch first {
    case let .degrees(value):
        return Angle(degrees: value - second.inDegrees)
    case let .radians(value):
        return Angle(radians: value - second.inRadians)
    }
}

func sine(_ theta: Angle) -> CGFloat {
    return sin(theta.inRadians)
}

func cosine(_ theta: Angle) -> CGFloat {
    return cos(theta.inRadians)
}

func tangent(_ theta: Angle) -> CGFloat {
    return tan(theta.inRadians)
}

func secant(_ theta: Angle) -> CGFloat {
    return 1 / cosine(theta)
}

func cosecant(_ theta: Angle) -> CGFloat {
    return 1 / sine(theta)
}

func cotangent(_ theta: Angle) -> CGFloat {
    return 1 / tangent(theta)
}

// MARK: inverses

func arcSine(_ ratio: Double) -> Angle {
    /* TODO: do better with parametricity 2017-06-04 */
    return .radians(CGFloat(asin(ratio)))
}

func arcSine(_ ratio: CGFloat) -> Angle {
    return .radians(asin(ratio))
}

// MARK: - 

extension Angle : Equatable {
    public static func == (lhs:Angle, rhs:Angle) -> Bool {
        switch (lhs, rhs) {
        case (.radians(let left), .radians(let right)):
            return left == right
        case (.degrees(let left), .degrees(let right)):
            return left == right
        case (.radians, _), (.degrees, _):
            return lhs.inRadians == rhs.inRadians
        }
    }
}


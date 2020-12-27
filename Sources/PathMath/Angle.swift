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

    public var inDegrees: Value {
        switch self {
        case .degrees(let value):
            return value
        case .radians(let value):
            return radiansToDegrees(value)
        }
    }

    /* TODO: return Angle 2017-06-04 */
    /* TODO: __sinPi 2017-06-08 */
    public var inRadians: Value {
        switch self {
        case .degrees(let value):
            return degreesToRadians(value)
        case .radians(let value):
            return value
        }
    }

    public init(degrees value: Value) {
        self = .degrees(value)
    }

    public init(radians value: Value) {
        self = .radians(value)
    }

    private func divide(_ divisor: Value) -> Angle {
        switch self {
        case .degrees(let value):
            return Angle(degrees: value / divisor)
        case .radians(let value):
            return Angle(radians: value / divisor)
        }
    }

    private func degreesToRadians(_ degrees: Value) -> Value {
        degrees * (.pi / 180.0)
    }

    private func radiansToDegrees(_ radians: Value) -> Value {
        radians * (180.0 / .pi)
    }

    #if os(OSX)
        public var apiValue: Value {
            inDegrees
        }
    #endif

    #if os(iOS)
        public var apiValue: Value {
            inRadians
        }
    #endif
}

extension Angle {
    public func pointInCircle(_ center: CGPoint, radius: Value) -> CGPoint {
        let angleInRadians: Value = inRadians
        return CGPoint(x: center.x + (radius * cos(angleInRadians)), y: center.y + (radius * sin(angleInRadians)))
    }
}

internal func + (first: Angle, second: Angle) -> Angle {
    switch first {
    case .degrees(let value):
        return Angle(degrees: value + second.inDegrees)
    case .radians(let value):
        return Angle(radians: value + second.inRadians)
    }
}

internal func - (first: Angle, second: Angle) -> Angle {
    switch first {
    case .degrees(let value):
        return Angle(degrees: value - second.inDegrees)
    case .radians(let value):
        return Angle(radians: value - second.inRadians)
    }
}

func sine(_ theta: Angle) -> CGFloat {
    sin(theta.inRadians)
}

func cosine(_ theta: Angle) -> CGFloat {
    cos(theta.inRadians)
}

func tangent(_ theta: Angle) -> CGFloat {
    tan(theta.inRadians)
}

func secant(_ theta: Angle) -> CGFloat {
    1 / cosine(theta)
}

func cosecant(_ theta: Angle) -> CGFloat {
    1 / sine(theta)
}

func cotangent(_ theta: Angle) -> CGFloat {
    1 / tangent(theta)
}

// MARK: inverses

func arcSine(_ ratio: Double) -> Angle {
    /* TODO: do better with parametricity 2017-06-04 */
    .radians(CGFloat(asin(ratio)))
}

func arcSine(_ ratio: CGFloat) -> Angle {
    .radians(asin(ratio))
}

// MARK: -

extension Angle: Equatable {
    public static func == (lhs: Angle, rhs: Angle) -> Bool {
        switch (lhs, rhs) {
        case (.radians(let left), .radians(let right)):
            return left == right
        case (.degrees(let left), .degrees(let right)):
            return left == right
        case (.radians, _),
             (.degrees, _):
            return lhs.inRadians == rhs.inRadians
        }
    }
}

//
//  RightTriangle.swift
//  PathMath
//
//  Created by TJ Usiyan on 2017/06/04.
//  Copyright © 2017 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

///    ```
///     │\
///     │a\
///     │  \
///     │   \
///    B│    \ C
///     │     \
///     │      \
///     │c     b\
///     └───────
///         A
///    ```

public struct RightTriangle {
    public typealias FloatValue = CGFloat

    public let angleA: Angle
    public let angleB: Angle
    public let angleC: Angle = .degrees(90)

    public let lengthA: FloatValue
    public let lengthB: FloatValue
    public let lengthC: FloatValue

    public init(angleA: Angle,
                angleB: Angle,
                lengthA: FloatValue,
                lengthB: FloatValue,
                lengthC: FloatValue) {

        self.angleA = angleA
        self.angleB = angleB
        self.lengthA = lengthA
        self.lengthB = lengthB
        self.lengthC = lengthC
    }
}

extension RightTriangle {
    public init(lengthA: FloatValue,
                lengthB: FloatValue) {
        self.lengthA = lengthA
        self.lengthB = lengthB
        self.lengthC = sqrt(pow(lengthA, 2) + pow(lengthB, 2))

        self.angleA = arcSine(lengthA / lengthC)
        self.angleB = .radians(asin(lengthB / lengthC))
    }

    public init(lengthA: FloatValue,
                lengthC: FloatValue) {
        self.lengthA = lengthA
        self.lengthB = sqrt(pow(lengthC, 2) - pow(lengthA, 2))
        self.lengthC = lengthC

        self.angleA = .radians(asin(lengthA / lengthC))
        self.angleB = .radians(asin(lengthB / lengthC))
    }

    public init(lengthB: FloatValue,
                lengthC: FloatValue) {
        self.lengthA = sqrt(pow(lengthC, 2) - pow(lengthB, 2))
        self.lengthB = lengthB
        self.lengthC = lengthC

        self.angleA = .radians(asin(lengthA / lengthC))
        self.angleB = .radians(asin(lengthB / lengthC))
    }

    // MARK: -

    public init(angleA: Angle,
                lengthA: FloatValue) {

        self.angleA = angleA
        self.angleB = .degrees(90) - angleA

        self.lengthA = lengthA
        self.lengthB = (1 / tangent(angleA)) / lengthA
        self.lengthC = (1 / sine(angleA)) / lengthA
    }

    public init(angleA: Angle,
                lengthB: FloatValue) {

        self.angleA = angleA
        self.angleB = .degrees(90) - angleA

        self.lengthA = tangent(angleA) * lengthB
        self.lengthB = lengthB
        self.lengthC = (1 / cosine(angleA)) / lengthB
    }


    public init(angleA: Angle,
                lengthC: FloatValue) {

        self.angleA = angleA
        self.angleB = .degrees(90) - angleA

        self.lengthA = sine(angleA) * lengthC
        self.lengthB = cosine(angleA) * lengthC
        self.lengthC = lengthC
    }

}

//
//  Coordinates2D.swift
//  PathMath
//
//  Created by TJ Usiyan on 2017/06/03.
//  Copyright © 2017 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

enum Coordinate2D : CustomStringConvertible {
    public typealias Value = CGFloat
    case cartesian(x: Value, y: Value)
    case polar(radius: Value, azimuth: Value)

    init(cartesianFrom original: Coordinate2D) {
        switch original {
        case .cartesian:
            self = original
        case .polar(let radius, let azimuth):
            self = .cartesian(x: radius * cos(azimuth),
                              y: radius * sin(azimuth))
        }
    }

    init(polarFrom original: Coordinate2D) {
        switch original {
        case .cartesian(let x, let y):

            let radius = sqrt(pow(x, 2) + pow(y, 2))
            let azimuth = atan2(x, y)
            self = .polar(radius: radius,
                          azimuth: azimuth)

        case .polar:
            self = original
        }
    }

    var description: String {
        switch self {
        case .cartesian(let x, let y):
            return "(x: \(x), y: \(y))"
        case .polar(let radius, let azimuth):
            return "(radius: \(radius), azimuth: \(azimuth))"
        }
    }
}

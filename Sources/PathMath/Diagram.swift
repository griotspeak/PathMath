//
//  Diagram.swift
//  PathMath
//
//  Created by TJ Usiyan on 2017/05/31.
//  Copyright © 2017 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

// designated init
public struct Diagram {
    let algebra: Algebra

    init(algebra: Algebra) {
        self.algebra = algebra
    }
}

// convenience initializers
extension Diagram {
    public static func circle(radius: CGFloat, center: CGPoint) -> Diagram {
        Diagram(algebra: .circle(radius: radius, center: center))
    }
}

extension Diagram {
    public func bounds(originLocation: OriginLocation = .defaultPlatformLocation) -> CGRect {
        switch algebra {
        case .circle(let r, let c):
            let edges: CGRect.EdgeDescription = (
                top: c.y.up(amount: r, originLocation: originLocation),
                right: c.x + r,
                bottom: c.y.down(amount: r, originLocation: originLocation),
                left: c.x - r)
            return CGRect(edges: edges,
                          originLocation: originLocation)
        }
    }
}

extension Diagram {
    enum Algebra {
        case circle(radius: CGFloat, center: CGPoint)
        //        case line
    }
}

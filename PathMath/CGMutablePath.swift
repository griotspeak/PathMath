//
//  CGMutablePath.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/26/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

import CoreGraphics

extension CGMutablePath {
    public func moveToPoint(point: CGPoint, var transform: CGAffineTransform = CGAffineTransformIdentity) {
        CGPathMoveToPoint(self, &transform, point.x, point.y)
    }

    public func addLineToPoint(point: CGPoint, var transform: CGAffineTransform = CGAffineTransformIdentity) {
        CGPathAddLineToPoint(self, &transform, point.x, point.y)
    }

    public func addArcWithCenter(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, rightwise: Bool, var transform: CGAffineTransform = CGAffineTransformIdentity) {
        CGPathAddArc(self, &transform, center.x, center.y, radius, startAngle, endAngle, CGMutablePath.convertRightwiseToClockwise(rightwise))
    }

    public func closePath() {
        CGPathCloseSubpath(self)
    }

    public static func convertRightwiseToClockwise(rightwise:Bool) -> Bool {
        #if os(OSX)
            return !rightwise
        #endif

        #if os(iOS)
            return rightwise
        #endif
    }
}

//
//  CGMutablePath.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/26/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

import CoreGraphics

extension CGMutablePath {
    public func moveToPoint(point: CGPoint, transform: CGAffineTransform = CGAffineTransformIdentity) {
        var _transform = transform
        CGPathMoveToPoint(self, &_transform, point.x, point.y)
    }

    public func addLineToPoint(point: CGPoint, transform: CGAffineTransform = CGAffineTransformIdentity) {
        var _transform = transform
        CGPathAddLineToPoint(self, &_transform, point.x, point.y)
    }

    public func addArcWithCenter(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, rightwise: Bool, transform: CGAffineTransform = CGAffineTransformIdentity) {
        var _transform = transform
        CGPathAddArc(self, &_transform, center.x, center.y, radius, startAngle, endAngle, CGMutablePath.convertRightwiseToClockwise(rightwise))
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

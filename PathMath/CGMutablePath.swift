//
//  CGMutablePath.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/26/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

import CoreGraphics

extension CGMutablePath {
    public func moveToPoint(_ point: CGPoint, transform: CGAffineTransform = CGAffineTransform.identity) {
        var _transform = transform
        self.moveTo(&_transform, x: point.x, y: point.y)
    }

    public func addLineToPoint(_ point: CGPoint, transform: CGAffineTransform = CGAffineTransform.identity) {
        var _transform = transform
        self.addLineTo(&_transform, x: point.x, y: point.y)
    }

    public func addArcWithCenter(_ center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, rightwise: Bool, transform: CGAffineTransform = CGAffineTransform.identity) {
        var _transform = transform
        self.addArc(&_transform, x: center.x, y: center.y, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: CGMutablePath.convertRightwiseToClockwise(rightwise))
    }

    public func closePath() {
        self.closeSubpath()
    }

    public static func convertRightwiseToClockwise(_ rightwise:Bool) -> Bool {
        #if os(OSX)
            return !rightwise
        #endif

        #if os(iOS)
            return rightwise
        #endif
    }
}

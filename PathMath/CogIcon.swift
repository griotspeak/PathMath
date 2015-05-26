//
//  CogIcon.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/25/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

import Foundation

public struct CogIcon<BezierPath: BezierPathType> {

    public let holeRadius:CGFloat
    public let radius:CGFloat
    public let spokeHeight:CGFloat
    public let toothCount:Int
    public let rotation:ArcLength

    private var bodyRadius:CGFloat {
        return radius - spokeHeight
    }

    private var center:CGPoint {
        return CGPointMake(radius, radius)
    }

    public func path()-> BezierPath {

        let imageArcLength:ArcLength = ArcLength(degrees: 360.0 / CGFloat(toothCount))
        let imageHalfArcLength:ArcLength = ArcLength(degrees: imageArcLength.inDegrees * 0.5)
        let toothPadding:ArcLength = imageHalfArcLength.divide(8.0)

        let foo = ArcLength(radians: imageHalfArcLength.inRadians / 8.0)

        var path = BezierPath()
        path.bezierLineJoinStyle = .Round
        path.usesEvenOddFillRule = true

        path.moveToPoint(pointInCircle(center, bodyRadius, rotation))

        for i in 0..<toothCount {
            let iImageOrigin = ArcLength(degrees: CGFloat(i) * imageArcLength.inDegrees) + rotation

            // tooth
            path.addLineToPoint(pointInCircle(center, radius, iImageOrigin))
            path.addArcWithCenter(center,
                radius: radius,
                startAngle: iImageOrigin.apiValue,
                endAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                clockwise: BezierPath.scrubClockwiseValue(true))

            path.addLineToPoint(pointInCircle(center, bodyRadius, iImageOrigin + imageHalfArcLength))
            // trough
            path.addArcWithCenter(center,
                radius: bodyRadius,
                startAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                endAngle: (iImageOrigin + imageArcLength).apiValue,
                clockwise: BezierPath.scrubClockwiseValue(true))
        }

        path.closePath()


        path.moveToPoint(pointInCircle(center, holeRadius, ArcLength(radians: 0)))
        path.addArcWithCenter(center,
            radius: holeRadius,
            startAngle: ArcLength(degrees:0).apiValue,
            endAngle: ArcLength(degrees:360).apiValue,
            clockwise: BezierPath.scrubClockwiseValue(true))
        return path
    }


    public init(holeRadius:CGFloat = 20, radius:CGFloat = 60, spokeHeight:CGFloat = 10, teethCount:Int = 6, rotation:ArcLength? = nil) {
        self.holeRadius = holeRadius
        self.radius = radius
        self.spokeHeight = spokeHeight
        self.toothCount = teethCount
        if let theRotation = rotation {
            self.rotation = theRotation
        } else {
            self.rotation = ArcLength(degrees:  -(360.0 / CGFloat(toothCount) * 0.25 - 90))
        }
        
    }
}

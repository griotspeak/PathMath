//
//  CogIcon.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/25/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

import CoreGraphics

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
    public var diameter:CGFloat {
        return radius * 2.0
    }

    public var bounds:CGRect {
        return CGRect(x: 0, y: 0, width: diameter, height: diameter)
    }

    public var path:CGPathRef {

        let imageArcLength:ArcLength = ArcLength(degrees: 360.0 / CGFloat(toothCount))
        let imageHalfArcLength:ArcLength = ArcLength(degrees: imageArcLength.inDegrees * 0.5)
        let toothPadding:ArcLength = imageHalfArcLength.divide(8.0)

        let foo = ArcLength(radians: imageHalfArcLength.inRadians / 8.0)

        var thePath = CGPathCreateMutable()

        thePath.moveToPoint(pointInCircle(center, bodyRadius, rotation))

        for i in 0..<toothCount {
            let iImageOrigin = ArcLength(degrees: CGFloat(i) * imageArcLength.inDegrees) + rotation

            // tooth
            thePath.addLineToPoint(pointInCircle(center, radius, iImageOrigin))
            thePath.addArcWithCenter(center,
                radius: radius,
                startAngle: iImageOrigin.inRadians,
                endAngle: (iImageOrigin + imageHalfArcLength).inRadians,
                rightwise: true)

            thePath.addLineToPoint(pointInCircle(center, bodyRadius, iImageOrigin + imageHalfArcLength))
            // trough
            thePath.addArcWithCenter(center,
                radius: bodyRadius,
                startAngle: (iImageOrigin + imageHalfArcLength).inRadians,
                endAngle: (iImageOrigin + imageArcLength).inRadians,
                rightwise: true)
        }

        thePath.closePath()


        thePath.moveToPoint(pointInCircle(center, holeRadius, ArcLength(radians: 0)))
        thePath.addArcWithCenter(center,
            radius: holeRadius,
            startAngle: ArcLength(degrees:0).inRadians,
            endAngle: ArcLength(degrees:360).inRadians,
            rightwise: true)
        return thePath
    }

    public var shapeLayer:CAShapeLayer {
        let theLayer = CAShapeLayer()
        theLayer.fillRule = kCAFillRuleEvenOdd
        let thePath = path
        theLayer.path = thePath
        return theLayer
    }


    // begin delete
    @availability(*, deprecated=0.0.1, message="Use path")
    public func bezierPath()-> BezierPath {

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

    // end delete


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

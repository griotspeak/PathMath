//
//  CogIcon.swift
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
import QuartzCore


public struct CogIcon {

    public let holeRadius:CGFloat
    public let diameter:CGFloat
    public let spokeHeight:CGFloat
    public let toothCount:Int
    public let rotation:ArcLength
    public let fillColor: CGColorRef?
    public let strokeColor: CGColorRef?


    private var bodyRadius:CGFloat {
        return radius - spokeHeight
    }

    private var center:CGPoint {
        return CGPointMake(radius, radius)
    }
    public var radius:CGFloat {
        return diameter * 0.5
    }

    public var bounds:CGRect {
        return CGRect(x: 0, y: 0, width: diameter, height: diameter)
    }

    public func createPath() -> CGPathRef {

        let imageArcLength:ArcLength = ArcLength(degrees: 360.0 / CGFloat(toothCount))
        let imageHalfArcLength:ArcLength = ArcLength(degrees: imageArcLength.inDegrees * 0.5)

        let thePath = CGPathCreateMutable()

        thePath.moveToPoint(pointInCircle(center, radius: bodyRadius, arcLength: rotation))

        for i in 0..<toothCount {
            let iImageOrigin = ArcLength(degrees: CGFloat(i) * imageArcLength.inDegrees) + rotation

            // tooth
            thePath.addLineToPoint(pointInCircle(center, radius: radius, arcLength: iImageOrigin))
            thePath.addArcWithCenter(center,
                radius: radius,
                startAngle: iImageOrigin.inRadians,
                endAngle: (iImageOrigin + imageHalfArcLength).inRadians,
                rightwise: true)

            thePath.addLineToPoint(pointInCircle(center, radius: bodyRadius, arcLength: iImageOrigin + imageHalfArcLength))
            // trough
            thePath.addArcWithCenter(center,
                radius: bodyRadius,
                startAngle: (iImageOrigin + imageHalfArcLength).inRadians,
                endAngle: (iImageOrigin + imageArcLength).inRadians,
                rightwise: true)
        }

        thePath.closePath()


        thePath.moveToPoint(pointInCircle(center, radius: holeRadius, arcLength: ArcLength(radians: 0)))
        thePath.addArcWithCenter(center,
            radius: holeRadius,
            startAngle: ArcLength(degrees:0).inRadians,
            endAngle: ArcLength(degrees:360).inRadians,
            rightwise: true)
        return thePath
    }

    public func createShapeLayer() -> CAShapeLayer {
        let theLayer = CAShapeLayer()
        theLayer.fillRule = kCAFillRuleEvenOdd
        theLayer.fillColor = fillColor
        theLayer.strokeColor = strokeColor
        let thePath = createPath()
        theLayer.path = thePath
        return theLayer
    }

    public init(holeRadius:CGFloat = 20
        , diameter:CGFloat = 60
        , spokeHeight:CGFloat = 10
        , teethCount:Int = 6
        , fillColor: CGColorRef? = nil
        , strokeColor: CGColorRef? = nil
        , rotation:ArcLength? = nil) {
            self.holeRadius = holeRadius
            self.diameter = diameter
            self.spokeHeight = spokeHeight
            self.fillColor = fillColor
            self.toothCount = teethCount
            self.strokeColor = strokeColor
            if let theRotation = rotation {
                self.rotation = theRotation
            } else {
                self.rotation = ArcLength(degrees:  -(360.0 / CGFloat(toothCount) * 0.25 - 90))
            }
    }
}


extension CogIcon {

    #if os(iOS)

    public func createView(size inSize: CGSize?, offset: CGPoint = CGPoint.zero) -> UIView {
        let size = inSize ?? CGSize(width: diameter, height: diameter)

        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: size))

        let iconLayer = createShapeLayer()

        let iconDiameter = diameter
        let uncenteredFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: iconDiameter, height: iconDiameter))
        let unshiftedFrame = CGRect(rect: uncenteredFrame, centeredIn: size)
        let iconFrame = CGRect(origin: CGPoint(x: unshiftedFrame.origin.x + offset.x, y: unshiftedFrame.origin.y + offset.y), size: unshiftedFrame.size)
        iconLayer.frame = iconFrame
        view.layer.addSublayer(iconLayer)
        
        return view
    }
    
    #endif
}
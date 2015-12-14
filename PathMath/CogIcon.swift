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


public struct CogIcon<BezierPath: BezierPathType> {

    public let holeRadius:CGFloat
    public let bodyRadius:CGFloat
    public let spokeHeight:CGFloat
    public let toothCount:Int
    public let rotation:ArcLength

    public var radius:CGFloat {
        return bodyRadius + spokeHeight
    }

    public var diameter: CGFloat {
        return radius * 2
    }

    public var center:CGPoint {
        return CGPointMake(radius, radius)
    }

    public func createPath()-> BezierPath {

        let imageArcLength:ArcLength = ArcLength(degrees: 360.0 / CGFloat(toothCount))
        let imageHalfArcLength:ArcLength = ArcLength(degrees: imageArcLength.inDegrees * 0.5)

        var path = BezierPath()
        path.bezierLineJoinStyle = .Round
        path.usesEvenOddFillRule = true

        path.moveToPoint(CogIcon.pointInCircle(center, radius: bodyRadius, arcLength: rotation))

        for i in 0..<toothCount {
            let iImageOrigin = ArcLength(degrees: CGFloat(i) * imageArcLength.inDegrees) + rotation

            // tooth
            path.addLineToPoint(CogIcon.pointInCircle(center, radius: radius, arcLength: iImageOrigin))
            path.addArcWithCenter(center,
                radius: radius,
                startAngle: iImageOrigin.apiValue,
                endAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                clockwise: BezierPath.scrubClockwiseValue(true))

            path.addLineToPoint(CogIcon.pointInCircle(center, radius: bodyRadius, arcLength: iImageOrigin + imageHalfArcLength))
            // trough
            path.addArcWithCenter(center,
                radius: bodyRadius,
                startAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                endAngle: (iImageOrigin + imageArcLength).apiValue,
                clockwise: BezierPath.scrubClockwiseValue(true))
        }

        path.closePath()


        path.moveToPoint(CogIcon.pointInCircle(center, radius: holeRadius, arcLength: ArcLength(radians: 0)))
        path.addArcWithCenter(center,
            radius: holeRadius,
            startAngle: ArcLength(degrees:0).apiValue,
            endAngle: ArcLength(degrees:360).apiValue,
            clockwise: BezierPath.scrubClockwiseValue(true))
        return path
    }

    public func createShapeLayer(fillColor: CGColorRef? = nil, strokeColor: CGColorRef? = nil) -> CAShapeLayer {
        let theLayer = CAShapeLayer()
        theLayer.fillRule = kCAFillRuleEvenOdd
        theLayer.fillColor = fillColor
        theLayer.strokeColor = strokeColor
        theLayer.path = createPath().quartzPath
        return theLayer
    }

    public init(diameter: CGFloat, relativeHoleDiameter: CGFloat, relativeSpokeHeight: CGFloat, toothCount: Int, rotation:ArcLength? = nil) {
        let radius = diameter * 0.5
        let holeRadius = radius * relativeHoleDiameter
        let spokeHeight = radius * relativeSpokeHeight
        self.init(holeRadius: holeRadius, bodyRadius: (radius - spokeHeight), spokeHeight: spokeHeight, toothCount: toothCount)
    }

    public init(holeRadius:CGFloat = 20, bodyRadius:CGFloat = 45, spokeHeight:CGFloat = 15, toothCount:Int = 6, rotation:ArcLength? = nil) {
        self.holeRadius = holeRadius
        self.bodyRadius = bodyRadius
        self.spokeHeight = spokeHeight
        self.toothCount = toothCount
        if let theRotation = rotation {
            self.rotation = theRotation
        } else {
            self.rotation = ArcLength(degrees:  -(360.0 / CGFloat(toothCount) * 0.25 - 90))
        }
    }

    private static func pointInCircle(center:CGPoint, radius:CGFloat, arcLength:ArcLength) -> CGPoint {
        let angleInRadians:CGFloat = arcLength.inRadians
        return CGPointMake(center.x + (radius * cos(angleInRadians)), center.y + (radius * sin(angleInRadians)))
    }

}

public protocol LayerBackedViewType {
    init(frame: CGRect)
    mutating func backingLayer() -> CALayer?
}


#if os(iOS)
    extension UIView : LayerBackedViewType {
        public func backingLayer() -> CALayer? {
            return layer
        }
    }
#endif

#if os(OSX)
    extension NSView : LayerBackedViewType {
        public func backingLayer() -> CALayer? {
            wantsLayer = true
            return layer
        }
    }
#endif


extension CogIcon {
    public func createView<ViewType : LayerBackedViewType>(frame: CGRect? = nil
        , fillColor: CGColorRef? = nil
        , strokeColor: CGColorRef? = nil) -> ViewType? {
            let size = frame?.size ?? CGSize(width: diameter, height: diameter)
            let offset = frame?.origin ?? CGPoint.zero

            var view = ViewType(frame: CGRect(origin: CGPoint.zero, size: size))

            let iconLayer = createShapeLayer()
            iconLayer.fillColor = fillColor
            iconLayer.strokeColor = strokeColor

            let iconDiameter = diameter
            let uncenteredFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: iconDiameter, height: iconDiameter))
            let unshiftedFrame = CGRect(rect: uncenteredFrame, centeredIn: size)
            let iconFrame = CGRect(origin: CGPoint(x: unshiftedFrame.origin.x + offset.x, y: unshiftedFrame.origin.y + offset.y), size: unshiftedFrame.size)
            iconLayer.frame = iconFrame
            view.backingLayer()?.addSublayer(iconLayer)

            return view
    }
}
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

public final class Icon<BezierPath: BezierPathType> {
    public typealias PathSetup = Void -> BezierPath
    public typealias FillRule = String
    public static func createShapeLayer(pathSetup pathSetup:PathSetup) -> CAShapeLayer {
        let theLayer = CAShapeLayer()
        let path = pathSetup()
        theLayer.path = path.quartzPath
        return theLayer
    }

    public static func createView<ViewType : LayerBackedViewType>(frame: CGRect, iconSize: CGSize, pathSetup:PathSetup) -> (ViewType, CAShapeLayer) {
        let iconFrame = CGRect(center: frame.center, size: iconSize)
        let size = frame.size
        var view = ViewType(frame: CGRect(origin: CGPoint.zero, size: size))
        let iconLayer = Icon<BezierPath>.createShapeLayer(pathSetup: pathSetup)
        iconLayer.frame = CGRect(origin: CGPoint.zero, size: iconFrame.size)
        iconLayer.position = iconFrame.center
        view.backingLayer()?.addSublayer(iconLayer)

        return (view, iconLayer)
    }
}

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

        let startingPoint = rotation.pointInCircle(center, radius: bodyRadius)
        path.moveToPoint(startingPoint)

        for i in 0..<toothCount {
            let iImageOrigin = ArcLength(degrees: CGFloat(i) * imageArcLength.inDegrees) + rotation

            // tooth
            path.addLineToPoint(iImageOrigin.pointInCircle(center, radius: radius))
            path.addArcWithCenter(center,
                radius: radius,
                startAngle: iImageOrigin.apiValue,
                endAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                clockwise: BezierPath.scrubClockwiseValue(true))

            let toothEnd = iImageOrigin + imageHalfArcLength
            path.addLineToPoint(toothEnd.pointInCircle(center, radius: bodyRadius))
            // trough
            path.addArcWithCenter(center,
                radius: bodyRadius,
                startAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                endAngle: (iImageOrigin + imageArcLength).apiValue,
                clockwise: BezierPath.scrubClockwiseValue(true))
        }

        path.moveToPoint(startingPoint)
        path.closePath()
        path.addCircleWithCenter(center, radius: holeRadius)
        return path
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
    public func createView<ViewType : LayerBackedViewType>(frame: CGRect? = nil) -> (ViewType, CAShapeLayer) {
        let viewFrame = frame ?? CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))

        let (view, iconLayer): (ViewType, CAShapeLayer) = Icon<BezierPath>.createView(viewFrame, iconSize: CGSize(width: diameter, height: diameter), pathSetup: createPath)
        iconLayer.fillRule = kCAFillRuleEvenOdd
        
        return (view, iconLayer)
    }
}

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
    public typealias PathSetup = () -> BezierPath
    public static func createShapeLayer(_ pathSetup:PathSetup) -> CAShapeLayer {
        let theLayer = CAShapeLayer()
        let path = pathSetup()
        theLayer.path = path.quartzPath
        return theLayer
    }

    public static func createView<ViewType : CALayerBackedType>(_ frame: CGRect, iconSize: CGSize, pathSetup:PathSetup) -> (ViewType, CAShapeLayer) {
        let iconFrame = CGRect(center: frame.center, size: iconSize)
        let size = frame.size
        var view = ViewType()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        guard let backingLayer = view.backingLayer() else { fatalError("unable to get or create backing layer for view \(view)") }

        let iconLayer = Icon<BezierPath>.createShapeLayer(pathSetup)
        iconLayer.frame = CGRect(origin: CGPoint.zero, size: iconFrame.size)
        iconLayer.position = iconFrame.center
        backingLayer.addSublayer(iconLayer)
        
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
        return CGPoint(x: radius, y: radius)
    }

    public func createPath()-> BezierPath {

        let imageArcLength:ArcLength = ArcLength(degrees: 360.0 / CGFloat(toothCount))
        let imageHalfArcLength:ArcLength = ArcLength(degrees: imageArcLength.inDegrees * 0.5)

        var path = BezierPath()
        path.bezierLineJoinStyle = .round
        path.usesEvenOddWindingRule = true

        let startingPoint = rotation.pointInCircle(center, radius: bodyRadius)
        path.move(to: startingPoint)

        for i in 0..<toothCount {
            let iImageOrigin = ArcLength(degrees: CGFloat(i) * imageArcLength.inDegrees) + rotation

            // tooth
            path.addLine(to: iImageOrigin.pointInCircle(center, radius: radius))
            path.addArc(withCenter: center,
                radius: radius,
                startAngle: iImageOrigin.apiValue,
                endAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                clockwise: BezierPath.platformClockwiseValue(fromActualClockwiseValue: true))

            let toothEnd = iImageOrigin + imageHalfArcLength
            path.addLine(to: toothEnd.pointInCircle(center, radius: bodyRadius))
            // trough
            path.addArc(withCenter: center,
                radius: bodyRadius,
                startAngle: (iImageOrigin + imageHalfArcLength).apiValue,
                endAngle: (iImageOrigin + imageArcLength).apiValue,
                clockwise: BezierPath.platformClockwiseValue(fromActualClockwiseValue: true))
        }

        path.close()
        path.move(to: startingPoint)
        path.addCircle(withCenter: center, radius: holeRadius, clockwise: BezierPath.platformClockwiseValue(fromActualClockwiseValue: true))
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

public protocol CALayerBackedType : _CALayerBackedType {
    init()
    var frame: CGRect { get set }
}

public protocol CAShapeLayerBackedType : _CALayerBackedType {
    var usesEvenOddFillRule: Bool { mutating get set }
    func backingLayer() -> CAShapeLayer?
}

extension CAShapeLayerBackedType {
    public var usesEvenOddFillRule: Bool {
        mutating get {
            return self.backingLayer()!.fillRule == kCAFillRuleEvenOdd
        }
        set(value) {
            self.backingLayer()!.fillRule = value ? kCAFillRuleEvenOdd : kCAFillRuleNonZero
        }
    }
}


extension CALayer : CALayerBackedType {
    public func backingLayer() -> Self? {
        return self
    }
}

extension CAShapeLayer : CAShapeLayerBackedType {
    public var usesEvenOddFillRule: Bool {
        get {
            return self.fillRule == kCAFillRuleEvenOdd
        }
        set(value) {
            self.fillRule = value ? kCAFillRuleEvenOdd : kCAFillRuleNonZero
        }
    }
}

#if os(iOS)
    public typealias PlatformBaseLayerBackedView = UIView
    extension UIView : CALayerBackedType {
        public func backingLayer() -> CALayer? {
            return layer
        }
    }

#endif

#if os(OSX)
    public typealias PlatformBaseLayerBackedView = NSView
    extension NSView : CALayerBackedType {
        public func backingLayer() -> CALayer? {
            wantsLayer = true
            return layer
        }
    }
#endif

extension CogIcon {
    public func createView<ViewType : CALayerBackedType>(_ frame: CGRect? = nil) -> (ViewType, CAShapeLayer) {
        let viewFrame = frame ?? CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))

        let (view, iconLayer): (ViewType, CAShapeLayer) = Icon<BezierPath>.createView(viewFrame, iconSize: CGSize(width: diameter, height: diameter), pathSetup: createPath)

        return (view, iconLayer)
    }
}

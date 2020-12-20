//
//  CGRect.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/12/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

extension CGRect {
    public typealias EdgeDescription = (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat)

    func edgeDescription(_ originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) -> EdgeDescription {
        let value: EdgeDescription
        value.left = minX
        value.right = maxX

        switch originLocation {
        case .lowerLeft:
            value.bottom = minY
            value.top = maxY
        case .upperLeft:
            value.bottom = maxY
            value.top = minY
        }

        return value
    }

    public typealias CornerDescription = (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint)
    func corners(_ originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) -> CornerDescription {
        let edges = edgeDescription(originLocation)

        return (
            topLeft: CGPoint(x: edges.left, y: edges.top),
            topRight: CGPoint(x: edges.right, y: edges.top),
            bottomLeft: CGPoint(x: edges.left, y: edges.bottom),
            bottomRight: CGPoint(x: edges.right, y: edges.bottom)
        )
    }
}

extension CGRect {
    public var center: CGPoint {
        CGPoint(x: origin.x + (size.width * 0.5), y: origin.y + (size.height * 0.5))
    }

    public init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        self.init(origin: origin, size: size)
    }

    public init(size innerSize: CGSize, centeredInRect outerRect: CGRect) {
        self.init(center: outerRect.center, size: innerSize)
    }

    public init(size innerSize: CGSize, centeredInSize outerSize: CGSize) {
        self.init(size: innerSize, centeredInRect: CGRect(origin: CGPoint.zero, size: outerSize))
    }

    public init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat, originLocation: OriginLocation = .defaultPlatformLocation) {
        let width = right - left
        let height: CGFloat
        let originY: CGFloat
        switch originLocation {
        case .lowerLeft:
            height = top - bottom
            originY = bottom
        case .upperLeft:
            height = bottom - top
            originY = top
        }
        self.init(origin: CGPoint(x: left,
                                  y: originY),
                  size: CGSize(width: width,
                               height: height))
    }

    public init(edges: EdgeDescription, originLocation: OriginLocation = .defaultPlatformLocation) {
        let originX = edges.left
        let originY: CGFloat
        let height: CGFloat
        let width = edges.right - edges.left

        switch originLocation {
        case .lowerLeft:
            originY = edges.bottom
            height = edges.top - edges.bottom
        case .upperLeft:
            originY = edges.top
            height = edges.bottom - edges.top
        }
        self.init(x: originX, y: originY, width: width, height: height)
    }
}

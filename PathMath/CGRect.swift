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

    public typealias CornerDescription = (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint,bottomRight: CGPoint)
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
        return CGPoint(x: origin.x + (size.width * 0.5), y: origin.y + (size.height * 0.5))
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
}

// MARK: - 2D grid

public struct CGRect2DGrid {

    public typealias Inset = (dX: CGFloat, dY: CGFloat)

    public let size: CGSize
    public let columns: Int
    public let rows: Int
    public let originLocation: OriginLocation
    public let defaultInset:Inset?
    private var _columns: CGFloat { return CGFloat(columns) }
    private var _rows: CGFloat { return CGFloat(rows) }

    public var columnWidth: CGFloat { return  size.width / _columns }
    public var rowHeight: CGFloat { return  size.height / _rows }

    public init(size: CGSize, columns: Int, rows: Int, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation, defaultInset:Inset? = nil) throws {
        guard size.width > 0 && size.height > 0 && columns > 0 && rows > 0 else { throw PathMathError.invalidArgument("all parameters must be greater than 0") }

        self.size = size
        self.columns = columns
        self.rows = rows
        self.originLocation = originLocation
        self.defaultInset = defaultInset
    }

    public enum PathMathError : Error {
        case invalidArgument(String)
    }

    public subscript(inColumn: Int, inRow: Int) -> CGRect? {
        return try? rect(inColumn, inRow: inRow)
    }

    public func rect(_ inColumn: Int, inRow: Int, dXdY:Inset? = nil) throws -> CGRect {
        guard inColumn < columns && inRow < rows else { throw PathMathError.invalidArgument("(\(inColumn), \(inRow)) is out of bounds (\(columns), \(rows))") }

        let point: CGPoint
        switch originLocation {
        case .upperLeft:
            point = CGPoint(x: inColumn, y: inRow)
        case .lowerLeft:
            point = CGPoint(x: inColumn, y: rows - inRow - 1)
        }

        let rHeight = rowHeight
        let cWidth = columnWidth

        let minX: CGFloat = point.x * cWidth
        let minY: CGFloat = point.y * rHeight
        let size: CGSize = CGSize(width: cWidth, height: rHeight)

        let rect = CGRect(origin: CGPoint(x: minX, y: minY), size: size)

        if let (dx, dy) = dXdY ?? defaultInset {
            return rect.insetBy(dx: dx, dy: dy)
        } else {
            return rect
        }
    }
}

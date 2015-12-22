//
//  CGRect.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/12/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

extension CGRect {
    init(rect: CGRect, centeredIn outerSize: CGSize) {
        let xOffset = (outerSize.width - rect.size.width) * 0.5
        let yOffset = (outerSize.height - rect.size.height) * 0.5

        self = CGRectIntegral(CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: rect.size))
    }

    public typealias EdgeDescription = (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat)

    func edgeDescription(originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) -> EdgeDescription {
        let value: EdgeDescription
        value.left = minX
        value.right = maxX

        switch originLocation {
        case .LowerLeft:
            value.bottom = minY
            value.top = maxY
        case .UpperLeft:
            value.bottom = maxY
            value.top = minY
        }

        return value
    }

    public typealias CornerDescription = (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint,bottomRight: CGPoint)
    func corners(originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) -> CornerDescription {
        let edges = edgeDescription(originLocation)

        return (
            topLeft: CGPoint(x: edges.left, y: edges.top),
            topRight: CGPoint(x: edges.right, y: edges.top),
            bottomLeft: CGPoint(x: edges.left, y: edges.bottom),
            bottomRight: CGPoint(x: edges.right, y: edges.bottom)
        )
    }
}

public struct CGRect2DGrid {
    public let size: CGSize
    public let columns: Int
    public let rows: Int
    public let originLocation: OriginLocation
    private var _columns: CGFloat { return CGFloat(columns) }
    private var _rows: CGFloat { return CGFloat(rows) }

    public var columnWidth: CGFloat { return  size.width / _columns }
    public var rowHeight: CGFloat { return  size.height / _rows }

    public init(size: CGSize, columns: Int, rows: Int, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation) throws {
        guard size.width > 0 && size.height > 0 && columns > 0 && rows > 0 else { throw Error.InvalidArgument("all parameters must be greater than 0") }

        self.size = size
        self.columns = columns
        self.rows = rows
        self.originLocation = originLocation
    }

    public enum Error : ErrorType {
        case InvalidArgument(String)
    }

    public subscript(inColumn: Int, inRow: Int) -> CGRect? {
        guard inColumn < columns && inRow < rows else { return nil }


        let point: CGPoint
        switch originLocation {
        case .UpperLeft:
            point = CGPoint(x: inColumn, y: inRow)
        case .LowerLeft:
            point = CGPoint(x: inColumn, y: rows - inRow - 1)
        }

        let rHeight = rowHeight
        let cWidth = columnWidth

        let minX: CGFloat = point.x * cWidth
        let minY: CGFloat = point.y * rHeight
        let size: CGSize = CGSize(width: cWidth, height: rHeight)

        return CGRect(origin: CGPoint(x: minX, y: minY), size: size)
    }
}
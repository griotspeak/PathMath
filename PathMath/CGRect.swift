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
}

public struct CGRect2DGrid {
    public let width: CGFloat
    public let height: CGFloat
    public let columns: Int
    public let rows: Int
    public let originLocation: OriginLocation
    private var _columns: CGFloat { return CGFloat(columns) }
    private var _rows: CGFloat { return CGFloat(rows) }

    public var columnWidth: CGFloat { return  width / _columns }
    public var rowHeight: CGFloat { return  height / _rows }

    public enum OriginLocation {
        case LowerLeft
        case UpperLeft

        #if os(OSX)
        public static let defaultSystemLocation:OriginLocation = .LowerLeft
        #endif

        #if os(iOS)
        public static let defaultPlatformLocation:OriginLocation = .UpperLeft
        #endif

    }


    public init(width: CGFloat, height: CGFloat, columns: Int, rows: Int, originLocation: OriginLocation = CGRect2DGrid.OriginLocation.defaultPlatformLocation) throws {
        guard width > 0 && height > 0 && columns > 0 && rows > 0 else { throw Error.InvalidArgument("all parameters must be greater than 0") }

        self.width = width
        self.height = height
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
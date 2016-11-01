//
//  CGRect2DGrid.swift
//  PathMath
//
//  Created by TJ Usiyan on 2016/13/08.
//  Copyright © 2016 Buttons and Lights LLC. All rights reserved.
//

// MARK: - 2D grid
import CoreGraphics

public struct CGRect2DGrid {

    public enum Inset {
        /// 0.0 - 1.0
        case proportional(xScale: CGFloat, yScale: CGFloat)
        case fixed(dX: CGFloat, dY: CGFloat)

        internal func convertToFixed(columnWidth: CGFloat, rowHeight: CGFloat) -> Inset {
            switch self {
            case let .proportional(xScale: xScale, yScale: yScale):
                return .fixed(dX: columnWidth * xScale , dY: rowHeight * yScale)
            case .fixed:
                return self
            }
        }
    }

    public let frame: CGRect
    public let columns: Int
    public let rows: Int
    public let originLocation: OriginLocation
    public let defaultCellInset:Inset?

    public static func columnWidth(columnCount: Int, gridWidth: CGFloat) -> CGFloat {
        return gridWidth / CGFloat(columnCount)
    }

    public static func rowHeight(rowCount: Int, gridHeight: CGFloat) -> CGFloat {
        return gridHeight / CGFloat(rowCount)
    }

    public var columnWidth: CGFloat { return  CGRect2DGrid.columnWidth(columnCount: columns, gridWidth: size.width) }
    public var rowHeight: CGFloat { return  CGRect2DGrid.rowHeight(rowCount: columns, gridHeight: size.height) }
    public var origin: CGPoint {
        return frame.origin
    }
    public var size: CGSize {
        return frame.size
    }

    public init(frame: CGRect, columns: Int, rows: Int, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation, defaultCellInset:Inset? = nil) throws {
        guard frame.size.width > 0 && frame.size.height > 0 && columns > 0 && rows > 0 else { throw PathMathError.invalidArgument("all parameters must be greater than 0") }

        self.frame = frame
        self.columns = columns
        self.rows = rows
        self.originLocation = originLocation
        self.defaultCellInset = defaultCellInset?.convertToFixed(columnWidth: CGRect2DGrid.columnWidth(columnCount: columns, gridWidth: frame.size.width), rowHeight: CGRect2DGrid.rowHeight(rowCount: rows, gridHeight: frame.size.height))
    }

    public init(origin: CGPoint = CGPoint.zero, size: CGSize, columns: Int, rows: Int, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation, defaultCellInset:Inset? = nil) throws {

        try self.init(frame: CGRect(origin: origin, size: size), columns: columns, rows: rows, originLocation: originLocation, defaultCellInset: defaultCellInset)
    }

    public enum PathMathError : Error {
        case invalidArgument(String)
    }

    public subscript(column: Int, row: Int) -> CGRect? {
        return try? rect(column, row: row)
    }

    public func rect(_ column: Int, row: Int, inset: Inset? = nil) throws -> CGRect {
        guard column < columns && row < rows else { throw PathMathError.invalidArgument("(\(column), \(row)) is out of bounds (\(columns), \(rows))") }

        let point: CGPoint
        switch originLocation {
        case .upperLeft:
            point = CGPoint(x: column, y: row)
        case .lowerLeft:
            point = CGPoint(x: column, y: rows - row - 1)
        }

        let rHeight = rowHeight
        let cWidth = columnWidth

        let minX: CGFloat = point.x * cWidth
        let minY: CGFloat = point.y * rHeight
        let size: CGSize = CGSize(width: cWidth, height: rHeight)

        let rect = CGRect(origin: CGPoint(x: minX + origin.x, y: minY + origin.y), size: size)

        if case let .fixed(dx, dy)? = inset ?? defaultCellInset {
            return rect.insetBy(dx: dx, dy: dy)
        } else {
            return rect
        }
    }
}

extension CGRect2DGrid {
    public struct CoordinatePair : Comparable, Hashable, CustomStringConvertible {
        public let column: Int
        public let row: Int

        public init(column: Int, row: Int) {
            self.column = column
            self.row = row
        }

        public var hashValue: Int {
            return column.hashValue &+ row.hashValue
        }

        public var description: String {
            return "(\(column), \(row))"
        }
    }
}

public func == (lhs: CGRect2DGrid.CoordinatePair, rhs: CGRect2DGrid.CoordinatePair) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

public func < (lhs: CGRect2DGrid.CoordinatePair, rhs: CGRect2DGrid.CoordinatePair) -> Bool {
    if lhs.row < rhs.row {
        return true
    } else if lhs.row > rhs.row {
        return false
    } else {
        return lhs.column < rhs.column
    }
}

extension CGRect2DGrid : Collection, BidirectionalCollection {
    public typealias Index = CoordinatePair
    public var startIndex: CoordinatePair {
        return CoordinatePair(column: 0, row: 0)
    }

    public var endIndex: CoordinatePair {
        return CoordinatePair(column: 0, row: rows)
    }

    public subscript (_ index: CoordinatePair) -> CGRect {
        return self[index.column, index.row]!
    }

    public func index(after i: CoordinatePair) -> CoordinatePair {
        let newColumn = i.column + 1
        if newColumn < columns {
            return CoordinatePair(column: newColumn, row: i.row)
        }

        let newRow = i.row + 1

        if newRow <= rows {
            return CoordinatePair(column: 0, row: newRow)
        } else {
            fatalError("invalid index \(i)")
        }
    }

    public func index(before i: CGRect2DGrid.CoordinatePair) -> CGRect2DGrid.CoordinatePair {
        let newColumn = i.column - 1
        if newColumn >= 0 {
            return CoordinatePair(column: newColumn, row: i.row)
        }

        let newRow = i.row - 1

        if newRow >= 0 {
            return CoordinatePair(column: columns - 1, row: newRow)
        } else {
            fatalError("invalid index \(i)")
        }
    }
}

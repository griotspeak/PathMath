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

    public typealias Inset = (dX: CGFloat, dY: CGFloat)

    public let size: CGSize
    public let columns: Int
    public let rows: Int
    public let origin: CGPoint
    public let originLocation: OriginLocation
    public let defaultCellInset:Inset?
    private var _columnsAsCGFloat: CGFloat { return CGFloat(columns) }
    private var _rowsAsCGFloat: CGFloat { return CGFloat(rows) }

    public var columnWidth: CGFloat { return  size.width / _columnsAsCGFloat }
    public var rowHeight: CGFloat { return  size.height / _rowsAsCGFloat }

    public init(size: CGSize, columns: Int, rows: Int, origin: CGPoint = CGPoint.zero, originLocation: OriginLocation = OriginLocation.defaultPlatformLocation, defaultCellInset:Inset? = nil) throws {
        guard size.width > 0 && size.height > 0 && columns > 0 && rows > 0 else { throw PathMathError.invalidArgument("all parameters must be greater than 0") }

        self.size = size
        self.columns = columns
        self.rows = rows
        self.origin = origin
        self.originLocation = originLocation
        self.defaultCellInset = defaultCellInset
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

        if let (dx, dy) = inset ?? defaultCellInset {
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

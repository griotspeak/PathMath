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
    public let originLocation: OriginLocation
    public let defaultInset:Inset?
    private var _columnsAsCGFloat: CGFloat { return CGFloat(columns) }
    private var _rowsAsCGFloat: CGFloat { return CGFloat(rows) }

    public var columnWidth: CGFloat { return  size.width / _columnsAsCGFloat }
    public var rowHeight: CGFloat { return  size.height / _rowsAsCGFloat }

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

        let rect = CGRect(origin: CGPoint(x: minX, y: minY), size: size)

        if let (dx, dy) = inset ?? defaultInset {
            return rect.insetBy(dx: dx, dy: dy)
        } else {
            return rect
        }
    }
}

extension CGRect2DGrid {
    public struct CoordinatePair : Comparable, Hashable {
        let column: Int
        let row: Int

        public var hashValue: Int {
            return column.hashValue &+ row.hashValue
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
        return lhs.column < lhs.column
    }
}

extension CGRect2DGrid : Collection {
    public typealias Index = CoordinatePair
    public var startIndex: CoordinatePair {
        return CoordinatePair(column: 0, row: 0)
    }

    public var endIndex: CoordinatePair {
        return CoordinatePair(column: columns - 1, row: rows - 1)
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

        if newRow < rows {
            return CoordinatePair(column: 0, row: newRow)
        } else {
            fatalError()
        }
    }
}

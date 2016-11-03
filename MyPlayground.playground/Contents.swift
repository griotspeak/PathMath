#if os(macOS)
    import AppKit
#endif
#if os(iOS)
    import UIKit
#endif
import XCPlayground
import PathMath

#if os(macOS)
let theCog = CogIcon<NSBezierPath>()
    typealias PlatformColor = NSColor
    typealias PlatformImage = NSImage
#endif

#if os(iOS)
let theCog = CogIcon<UIBezierPath>()
    typealias PlatformColor = UIColor
    typealias PlatformImage = UIImage
#endif


enum Foo {
    case First(Bool)
    case Second(Bool)
}

var (theView, theLayer): (PlatformBaseLayerBackedView, CAShapeLayer) = theCog.createView(CGRect(x: 0, y: 0, width: 150, height: 150))
theLayer.strokeColor = PlatformColor.white.cgColor
theLayer.fillColor = PlatformColor.lightGray.cgColor
theLayer.usesEvenOddFillRule = true
//theView.backgroundColor = NSColor.blackColor()

theView

var path = PlatformBezierPath()
let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 25))
path.add(rect, cornerRadius: 5)
path.removeAllPoints()
path.add(rect)

let frame = CGRect(x: 0, y: 0, width: 40, height: 20)
guard let grid = try? CGRect2DGrid(size: frame.size, columns: 3, rows: 3) else { fatalError() }

let xInset:CGFloat = 1
let yInset:CGFloat = 1

guard let topRect = grid[0, 2]?.insetBy(dx: xInset, dy: yInset),
    let middleRect = grid[1, 1]?.insetBy(dx: xInset, dy: yInset),
    let bottomRect = grid[2, 0]?.insetBy(dx: xInset, dy: yInset) else {
        fatalError()
}

var bezierPath = PlatformBezierPath()
for rect in [topRect, middleRect, bottomRect] {
    bezierPath.add(rect)
}

bezierPath


var newFrame = theView.frame
newFrame.origin = CGPoint(x: 100, y: 100)
theView.frame = newFrame

let result: PlatformImage? = theView.renderLayerContents()

let grid_ = try! CGRect2DGrid(frame: CGRect(x: 0, y: 0, width: 20, height: 20), columns: 2, rows: 2, defaultCellInset: .proportional(xScale: 0.0, yScale: 0.0))
try? grid_.rect(column: -1, row: 1, inset: .proportional(xScale: 0.25, yScale: 0.25), bounded: false)

var idx = grid_.endIndex
for cell in grid_ {
    print(cell)
}

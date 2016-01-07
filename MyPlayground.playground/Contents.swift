#if os(OSX)
    import AppKit
#endif

#if os(iOS)
    import UIKit
#endif
import XCPlayground
import PathMath

#if os(OSX)
let theCog = CogIcon<NSBezierPath>()
typealias PlatformColor = NSColor
#endif

#if os(iOS)
let theCog = CogIcon<UIBezierPath>()
typealias PlatformColor = UIColor
#endif

enum Foo {
    case First(Bool)
    case Second(Bool)
}

var (theView, theLayer): (PlatformBaseLayerBackedView, CAShapeLayer) = theCog.createView(CGRect(x: 0, y: 0, width: 150, height: 150))
theLayer.strokeColor = PlatformColor.whiteColor().CGColor
theLayer.fillColor = PlatformColor.lightGrayColor().CGColor
//theView.backgroundColor = NSColor.blackColor()

theView

var path = PlatformBezierPath()
let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 25))
path.addRoundedRect(rect, cornerRadius: 5)
path.removeAllPoints()
path.addRect(rect)

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
    bezierPath.addRect(rect)
}

bezierPath

var newFrame = theView.frame
newFrame.origin = CGPoint(x: 100, y: 100)
theView.frame = newFrame

let result: NSImage? = theView.renderLayerContents()

result

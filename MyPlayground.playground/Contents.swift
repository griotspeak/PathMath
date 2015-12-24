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
#endif

#if os(iOS)
let theCog = CogIcon<UIBezierPath>()
#endif

//let (theView, theLayer): (UIView, CAShapeLayer) = theCog.createView(CGRect(x: 0, y: 0, width: 150, height: 150))
//theLayer.strokeColor = UIColor.whiteColor().CGColor
//theLayer.fillColor = UIColor.lightGrayColor().CGColor
//theView.backgroundColor = UIColor.blackColor()
//
//theView
//
//var path = UIBezierPath()
//let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 25))
//path.addRoundedRect(rect, cornerRadius: 5)
//path.removeAllPoints()
//path.addRect(rect)
//


let frame = CGRect(x: 0, y: 0, width: 250, height: 100)
guard let grid = try? CGRect2DGrid(size: frame.size, columns: 1, rows: 3) else { fatalError() }

let xInset:CGFloat = 3
let yInset:CGFloat = 3

guard let topRect = grid[0, 0]?.insetBy(dx: xInset, dy: yInset),
    let middleRect = grid[0, 1]?.insetBy(dx: xInset, dy: yInset),
    let bottomRect = grid[0, 2]?.insetBy(dx: xInset, dy: yInset) else {
        fatalError()
}

var bezierPath = UIBezierPath()
for rect in [topRect, middleRect, bottomRect] {
    bezierPath.addRect(rect)
}

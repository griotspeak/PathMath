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

let (theView, theLayer): (UIView, CAShapeLayer) = theCog.createView(CGRect(x: 0, y: 0, width: 150, height: 150))
theLayer.strokeColor = UIColor.whiteColor().CGColor
theLayer.fillColor = UIColor.lightGrayColor().CGColor
theView.backgroundColor = UIColor.blackColor()

theView

var path = UIBezierPath()
let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 25))
path.addRoundedRect(rect, cornerRadius: 5)
path.removeAllPoints()
path.addRect(rect)


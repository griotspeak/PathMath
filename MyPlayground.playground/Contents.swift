#if os(OSX)
    import AppKit
#endif

#if os(iOS)
    import UIKit
#endif
import XCPlayground
import PathMath

//#if os(OSX)
//let theCog = CogIcon<NSBezierPath>()
//#endif
//
//#if os(iOS)
//let theCog = CogIcon<UIBezierPath>()
//#endif
//
//let thePath:UIView = theCog.createView(fillColor: UIColor.whiteColor().CGColor, strokeColor: nil)!
//

let grid = try! CGRect2DGrid(width: 100, height: 100, columns: 4, rows: 4, originLocation: .UpperLeft)
grid[0, 0]


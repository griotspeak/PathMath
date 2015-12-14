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

let thePath:UIView = theCog.createView(fillColor: UIColor.whiteColor().CGColor, strokeColor: nil)!

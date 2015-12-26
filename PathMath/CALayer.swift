//
//  CALayer.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/26/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore
#if os(OSX)
import AppKit
#endif

#if os(iOS)
import UIKit

    extension CALayer {

        public func pathMathImage() -> UIImage? {
            let rect = CGRect(origin: CGPoint.zero, size: bounds.size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)

            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            defer { UIGraphicsEndImageContext() }

            CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
            CGContextFillRect(context, rect)
            renderInContext(context)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
            
        }
    }

    extension UIView {
        public func pathMathImage() ->UIImage? {
            return layer.pathMathImage()
        }
    }
#endif


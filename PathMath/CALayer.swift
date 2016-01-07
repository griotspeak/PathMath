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

    extension NSBitmapImageRep {
        internal static func createPathMathImage(size: NSSize, pathMathDrawingHandler: (CGContext, NSSize) -> Bool) -> NSBitmapImageRep? {
            guard let convertedBounds = NSScreen.mainScreen()?.convertRectToBacking(NSRect(origin: CGPoint.zero, size: size)).integral,
                let intermediateImageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(convertedBounds.width), pixelsHigh: Int(convertedBounds.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bitmapFormat: .NSAlphaFirstBitmapFormat, bytesPerRow: 0, bitsPerPixel: 0),
                let imageRep = intermediateImageRep.bitmapImageRepByRetaggingWithColorSpace(.sRGBColorSpace())
                else { return nil }

            imageRep.size = size
            guard let bitmapContext = NSGraphicsContext(bitmapImageRep: imageRep) else { return nil }
            NSGraphicsContext.saveGraphicsState()
            defer { NSGraphicsContext.restoreGraphicsState() }

            NSGraphicsContext.setCurrentContext(bitmapContext)

            let quartzContext = bitmapContext.CGContext

            if pathMathDrawingHandler(quartzContext, size) {
                return imageRep
            } else {
                return nil
            }

        }
    }

    extension NSView {
        public func pathMathImage() -> NSBitmapImageRep? {

            return NSBitmapImageRep.createPathMathImage(bounds.size) { (context, size) in
                guard let containerLayer = self.layer else { return false }

                containerLayer.renderInContext(context)
                return true
            }
        }
    }
#endif

#if os(iOS)
    import UIKit
    extension CALayer {
        public func pathMathImage() -> UIImage? {
            let rect = CGRect(origin: CGPoint.zero, size: bounds.size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)

            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
            CGContextFillRect(context, rect)
            renderInContext(context)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }

    extension UIView {
        public func pathMathImage() ->UIImage? {
            return layer.pathMathImage()
        }
    }
#endif


//
//  Rendering.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/26/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

public protocol RenderDrawingType {
    /* TODO: abstract over the context type 2016-01-07 */
    static func renderDrawing(size: CGSize, drawingHandler: (CGContext, CGSize) -> Bool) -> Self?
}

public protocol _CALayerBackedType {
    mutating func backingLayer() -> CALayer?
}

extension _CALayerBackedType {
    public mutating func renderLayerContents<Output : RenderDrawingType>() -> Output? {
        guard let containerLayer = backingLayer() else { return nil }
        return Output.renderDrawing(containerLayer.bounds.size) { (context, size) in
            containerLayer.renderInContext(context)
            return true
        }
    }
}

#if os(OSX)
    import AppKit

    extension NSBitmapImageRep : RenderDrawingType {
        public static func renderDrawing(size: CGSize, drawingHandler: (CGContext, CGSize) -> Bool) -> Self? {
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

            guard drawingHandler(quartzContext, size) else { return nil }

            /* TODO: This seems wasteful… find something better? 2016-01-07 */
            return imageRep.CGImage.map { self.init(CGImage: $0) }
        }
    }

    extension NSImage : RenderDrawingType {
        public static func renderDrawing(size: CGSize, drawingHandler: (CGContext, CGSize) -> Bool) -> Self? {
            return self.init(size: size, flipped: false) { (frame) in
                guard let context = NSGraphicsContext.currentContext() else { return false }
                let quartzContext = context.CGContext
                return drawingHandler(quartzContext, frame.size)
            }
        }
    }

#endif

#if os(iOS)
    import UIKit

    extension UIImage : RenderDrawingType {
        public static func renderDrawing(size: CGSize, drawingHandler: (CGContext, CGSize) -> Bool) -> Self? {
            if let oldContext = UIGraphicsGetCurrentContext() {
                CGContextSaveGState(oldContext)
                defer { CGContextRestoreGState(oldContext) }
            }

            let rect = CGRect(origin: CGPoint.zero, size: size)

            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            defer { UIGraphicsEndImageContext() }

            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
            CGContextFillRect(context, rect)

            drawingHandler(context, size)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            guard let imageData = UIImagePNGRepresentation(image) else { return nil }

            /* TODO: This seems wasteful… find something better? 2016-01-07 */
            return self.init(data: imageData)
        }
    }
#endif


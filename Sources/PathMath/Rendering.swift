//
//  Rendering.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/26/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

public protocol _CALayerBackedType {
    mutating func backingLayer() -> CALayer?
}

/* TODO: appease the gods 2016-01-07 */
// public protocol RenderDrawingType {
//    /* TODO: abstract over the context type 2016-01-07 */
//    static func renderDrawing(size: CGSize, drawingHandler: (CGContext, CGSize) -> Bool) -> Self?
// }
//
// extension _CALayerBackedType {
//    public mutating func renderLayerContents<Output : RenderDrawingType>() -> Output? {
//        guard let containerLayer = backingLayer() else { return nil }
//        return Output.renderDrawing(containerLayer.bounds.size) { (context, size) in
//            containerLayer.renderInContext(context)
//            return true
//        }
//    }
// }

#if os(OSX)
    import AppKit
    extension CALayer {
        @nonobjc public func renderLayerContents() -> NSBitmapImageRep? {
            guard let containerLayer = backingLayer() else { return nil }
            return NSBitmapImageRep.renderDrawing(containerLayer.bounds.size) { context, size in
                containerLayer.render(in: context)
                return true
            }
        }
    }

    extension CALayer {
        @nonobjc public func renderLayerContents() -> NSImage? {
            guard let containerLayer = backingLayer() else { return nil }
            return NSImage.renderDrawing(containerLayer.bounds.size) { context, size in
                containerLayer.render(in: context)
                return true
            }
        }
    }

    extension NSView {
        @nonobjc public func renderLayerContents() -> NSBitmapImageRep? {
            guard let containerLayer = backingLayer() else { return nil }
            return NSBitmapImageRep.renderDrawing(containerLayer.bounds.size) { context, size in
                containerLayer.render(in: context)
                return true
            }
        }
    }

    extension NSView {
        @nonobjc public func renderLayerContents() -> NSImage? {
            guard let containerLayer = backingLayer() else { return nil }
            return NSImage.renderDrawing(containerLayer.bounds.size) { context, size in
                containerLayer.render(in: context)
                return true
            }
        }
    }

    extension NSBitmapImageRep {
        @nonobjc public static func renderDrawing(_ size: CGSize, drawingHandler: (CGContext, CGSize) -> Bool) -> Self? {
            guard let convertedBounds = NSScreen.main?.convertRectToBacking(NSRect(origin: CGPoint.zero, size: size)).integral,
                  let intermediateImageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(convertedBounds.width), pixelsHigh: Int(convertedBounds.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.calibratedRGB, bitmapFormat: NSBitmapImageRep.Format.alphaFirst, bytesPerRow: 0, bitsPerPixel: 0),
                  let imageRep = intermediateImageRep.retagging(with: .sRGB)
            else { return nil }
            imageRep.size = size
            guard let bitmapContext = NSGraphicsContext(bitmapImageRep: imageRep) else { return nil }
            NSGraphicsContext.saveGraphicsState()
            defer { NSGraphicsContext.restoreGraphicsState() }

            NSGraphicsContext.current = bitmapContext

            let quartzContext = bitmapContext.cgContext

            guard drawingHandler(quartzContext, size) else { return nil }

            /* TODO: This seems wasteful… find something better? 2016-01-07 */
            return imageRep.cgImage.map { self.init(cgImage: $0) }
        }
    }

    extension NSImage {
        @nonobjc public static func renderDrawing(_ size: CGSize, drawingHandler: @escaping (CGContext, CGSize) -> Bool) -> Self? {
            self.init(size: size, flipped: false) { frame in
                guard let context = NSGraphicsContext.current else { return false }
                let quartzContext = context.cgContext
                return drawingHandler(quartzContext, frame.size)
            }
        }
    }

#endif

#if os(iOS)
    import UIKit
    extension CALayer {
        @nonobjc public func renderLayerContents() -> UIImage? {
            guard let containerLayer = backingLayer() else { return nil }
            return UIImage.renderDrawing(containerLayer.bounds.size) { context, size in
                containerLayer.render(in: context)
            }
        }
    }

    extension UIView {
        @nonobjc public func renderLayerContents() -> UIImage? {
            guard let containerLayer = backingLayer() else { return nil }
            return UIImage.renderDrawing(containerLayer.bounds.size) { context, size in
                containerLayer.render(in: context)
            }
        }
    }

    extension UIImage {
        @nonobjc public static func renderDrawing(_ size: CGSize, drawingHandler: (CGContext, CGSize) -> Void) -> UIImage? {
            let rect = CGRect(origin: CGPoint.zero, size: size)

            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            defer { UIGraphicsEndImageContext() }

            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)

            drawingHandler(context, size)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
//            guard let imageData = UIImagePNGRepresentation(image) else { return nil }
//
//            /* TODO: This seems wasteful… find something better? 2016-01-07 */
//            return self.init(data: imageData)
        }
    }
#endif

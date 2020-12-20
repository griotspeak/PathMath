//
//  CGMutablePath.swift
//  PathMath
//
//  Created by TJ Usiyan on 5/26/15.
//  Copyright (c) 2015 Buttons and Lights LLC. All rights reserved.
//

import CoreGraphics

extension CGMutablePath {
    public func close() {
        closeSubpath()
    }

    public static func convertRightwiseToClockwise(_ rightwise: Bool) -> Bool {
        #if os(OSX)
            return !rightwise
        #endif

        #if os(iOS)
            return rightwise
        #endif
    }
}

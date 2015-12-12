//
//  CGRect.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/12/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore


extension CGRect {
    init(rect: CGRect, centeredIn outerSize: CGSize) {
        let xOffset = (outerSize.width - rect.size.width) * 0.5
        let yOffset = (outerSize.height - rect.size.height) * 0.5

        self = CGRectIntegral(CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: rect.size))
    }
}

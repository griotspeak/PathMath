//
//  CGSize.swift
//  PathMath
//
//  Created by TJ Usiyan on 19/10/26.
//  Copyright © 2019 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

extension CGSize {
    public func positionedWithin(_ exterior: CGRect, relativeCenter: CGPoint, invertY: Bool = false) -> CGRect {
        let fullXRange = exterior.width - width
        let fullYRange = exterior.height - height

        let back = CGRect(
            origin: CGPoint(
                x: exterior.minX + (relativeCenter.x * fullXRange),
                y: exterior.minY + ((invertY ? (1 - relativeCenter.y) : relativeCenter.y) * fullYRange)
            ),
            size: self
        )

        return back
    }
}

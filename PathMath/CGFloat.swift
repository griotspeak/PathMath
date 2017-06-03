//
//  CGFloat.swift
//  PathMath
//
//  Created by TJ Usiyan on 2017/05/31.
//  Copyright © 2017 Buttons and Lights LLC. All rights reserved.
//

import QuartzCore

//typealias ComparableSignedNumeric = SignedNumeric & Comparable

extension CGFloat {
    func up(amount: CGFloat, originLocation: OriginLocation =
        .defaultPlatformLocation) -> CGFloat {
        
        guard amount >= 0 else {
            fatalError("delta must be non-negative")
        }
        switch originLocation {
        case .lowerLeft:
            return self + amount
        case .upperLeft:
            return self - amount
        }
    }

    func down(amount: CGFloat, originLocation: OriginLocation =
        .defaultPlatformLocation) -> CGFloat {

        guard amount >= 0 else {
            fatalError("delta must be non-negative")
        }
        switch originLocation {
        case .lowerLeft:
            return self - amount
        case .upperLeft:
            return self + amount
        }
    }
}

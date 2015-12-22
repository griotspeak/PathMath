//
//  OriginLocation.swift
//  PathMath
//
//  Created by TJ Usiyan on 12/21/15.
//  Copyright © 2015 Buttons and Lights LLC. All rights reserved.
//

public enum OriginLocation {
    case LowerLeft
    case UpperLeft

    #if os(OSX)
    public static let defaultPlatformLocation:OriginLocation = .LowerLeft
    #endif

    #if os(iOS)
    public static let defaultPlatformLocation:OriginLocation = .UpperLeft
    #endif

}

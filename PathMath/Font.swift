//
//  Font.swift
//  PathMath
//
//  Created by TJ Usiyan on 20/2/11.
//  Copyright © 2020 Buttons and Lights LLC. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit
    public typealias PlatformFont = NSFont
#endif

#if os(iOS)
    import UIKit
    public typealias PlatformFont = UIFont
#endif

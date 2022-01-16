//
//  PlatformUtils.swift
//  Dokto
//
//  Created by Sanviraj Zahin Haque on 31/10/21.
//

import Foundation

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
#if arch(i386) || arch(x86_64)
        isSim = true
#endif
        return isSim
    }()
}

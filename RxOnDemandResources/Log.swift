//
//  Log.swift
//  RxOnDemandResources
//
//  Created by Maxim Volgin on 28/01/2018.
//  Copyright © 2018 Maxim Volgin. All rights reserved.
//

import os.log

struct Log {
    fileprivate static let subsystem: String = Bundle.main.bundleIdentifier ?? ""
    
    static let odr = OSLog(subsystem: subsystem, category: "odr")
}

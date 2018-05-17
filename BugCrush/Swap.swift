//
//  Swap.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

struct Swap: CustomStringConvertible, Hashable {
    let cookieA: Bug
    let cookieB: Bug
    
    init(cookieA: Bug, cookieB: Bug) {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var hashValue: Int {
        return cookieA.hashValue ^ cookieB.hashValue
    }
    
    static func ==(lhs: Swap, rhs: Swap) -> Bool {
        return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
            (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}
